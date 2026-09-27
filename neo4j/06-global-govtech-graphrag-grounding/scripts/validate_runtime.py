from __future__ import annotations

import os
import re

from src.govtech_graphrag import GovTechGraphRAG


def check(name: str, condition: bool, detail: str = "") -> None:
    if not condition:
        suffix = f" detail={detail}" if detail else ""
        print(f"FAIL {name}{suffix}")
        raise AssertionError(name)
    suffix = f" {detail}" if detail else ""
    print(f"PASS {name}{suffix}")


def metadata_urls(items) -> set[str]:
    return {
        item.metadata["source_url"]
        for item in items
        if item.metadata and item.metadata.get("source_url")
    }


def main() -> int:
    uri = os.getenv("NEO4J_URI", "neo4j://localhost:7687")
    username = os.getenv("NEO4J_USERNAME", "neo4j")
    password = os.getenv("NEO4J_PASSWORD", "neo4j-local-pow")

    with GovTechGraphRAG(uri, username, password) as app:
        check("driver_connectivity", True)

        app.reset_database()
        app.create_schema()
        app.seed_public_graph()

        counts = app.counts()
        check("system_count", counts["systems"] == 4, str(counts["systems"]))
        check("evidence_count", counts["evidence"] == 4, str(counts["evidence"]))
        check(
            "capability_count",
            counts["capabilities"] == 7,
            str(counts["capabilities"]),
        )
        check("enables_count", counts["enables"] == 10, str(counts["enables"]))

        check("vector_index_online", app.index_state() == "ONLINE", str(app.index_state()))
        dimensions = app.embedding_dimensions()
        check(
            "embedding_dimensions",
            dimensions == [8, 8, 8, 8],
            str(dimensions),
        )

        auth = app.search_context(
            "Which public systems support authentication and identity verification?",
            top_k=3,
        )
        auth_names = {
            item.metadata["system_name"]
            for item in auth.items
            if item.metadata
        }
        check(
            "vector_authentication_top3",
            auth_names == {"GOV.UK One Login", "Login.gov", "Singpass"},
            str(sorted(auth_names)),
        )
        check("vector_authentication_excludes_xroad", "X-Road" not in auth_names)

        auth_urls = metadata_urls(auth.items)
        check("graph_enrichment_official_sources", len(auth_urls) == 3, str(sorted(auth_urls)))
        check(
            "graph_enrichment_capabilities",
            all(
                item.metadata
                and item.metadata.get("capabilities")
                for item in auth.items
            ),
        )

        exchange = app.search_context(
            "secure data exchange interoperability",
            top_k=1,
        )
        exchange_name = exchange.items[0].metadata["system_name"]
        check("vector_exchange_top1", exchange_name == "X-Road", str(exchange_name))

        response = app.search_graphrag(
            "Which public digital systems in this sample support authentication, and where is the evidence?",
            top_k=3,
        )
        check("graphrag_answer_generated", response.answer.startswith("Grounded answer"))
        check(
            "graphrag_context_returned",
            response.retriever_result is not None
            and len(response.retriever_result.items) == 3,
        )

        returned_urls = metadata_urls(response.retriever_result.items)
        check("graphrag_context_has_sources", len(returned_urls) == 3)

        prompt = app.llm.last_input
        check(
            "grounding_prompt_contains_retrieved_evidence",
            "GOV.UK One Login" in prompt
            and "https://docs.sign-in.service.gov.uk/" in prompt,
        )

        answer_urls = set(re.findall(r"https://[^\s]+", response.answer))
        check("answer_contains_grounded_sources", len(answer_urls) == 3, str(sorted(answer_urls)))
        check(
            "answer_sources_subset_of_context",
            answer_urls.issubset(returned_urls),
            f"answer={sorted(answer_urls)} context={sorted(returned_urls)}",
        )

        print("VALIDATION_RESULT=PASS")
        return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"VALIDATION_RESULT=FAIL error={type(exc).__name__}: {exc}")
        raise
