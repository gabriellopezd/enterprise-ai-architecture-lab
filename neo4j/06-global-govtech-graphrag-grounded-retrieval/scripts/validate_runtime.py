from __future__ import annotations

import os
from pathlib import Path
from src.graphrag_app import GovTechGraphRAGApp

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "public_govtech_evidence.json"

def check(name: str, condition: bool, detail: str = "") -> None:
    if not condition:
        suffix = f" detail={detail}" if detail else ""
        print(f"FAIL {name}{suffix}")
        raise AssertionError(name)
    suffix = f" {detail}" if detail else ""
    print(f"PASS {name}{suffix}")

def content_text(items) -> str:
    return "\n".join(str(item.content) for item in items)

def main() -> int:
    uri = os.getenv("NEO4J_URI", "neo4j://localhost:7687")
    username = os.getenv("NEO4J_USERNAME", "neo4j")
    password = os.getenv("NEO4J_PASSWORD", "neo4j-local-pow")
    with GovTechGraphRAGApp(uri, username, password) as app:
        check("driver_connectivity", True)
        app.reset()
        app.create_constraints()
        app.seed(DATA)
        app.create_vector_index()

        counts = app.counts()
        check("system_count", counts["systems"] == 4, str(counts["systems"]))
        check("evidence_count", counts["evidence"] == 4, str(counts["evidence"]))
        check("capability_count", counts["capabilities"] == 7, str(counts["capabilities"]))
        check("enables_count", counts["enables"] == 13, str(counts["enables"]))

        query = "Which public digital government systems support secure authentication and identity verification?"

        vector = app.vector_search(query, top_k=3)
        check("vector_retrieval_count", len(vector.items) == 3, str(len(vector.items)))
        vector_text = content_text(vector.items)
        check("vector_retrieval_relevant", "GOV.UK One Login" in vector_text or "Login.gov" in vector_text, vector_text[:500])
        check("vector_score_present", all("score" in item.metadata for item in vector.items), str([item.metadata for item in vector.items]))

        enhanced = app.graph_enhanced_search(query, top_k=3)
        check("graph_enhanced_count", len(enhanced.items) == 3, str(len(enhanced.items)))
        enhanced_text = content_text(enhanced.items)
        check("graph_context_has_system", "system" in enhanced_text.lower(), enhanced_text[:500])
        check("graph_context_has_capabilities", "capabilities" in enhanced_text.lower(), enhanced_text[:500])
        check("graph_context_has_source", "https://" in enhanced_text, enhanced_text[:500])

        rag = app.graphrag_search(query, top_k=3)
        check("graphrag_answer_present", bool(rag.answer.strip()), rag.answer)
        check("graphrag_context_returned", rag.retriever_result is not None)
        rag_context = content_text(rag.retriever_result.items)
        check("graphrag_context_has_official_url", "https://" in rag_context, rag_context[:500])
        check(
            "generation_received_context",
            "https://" in app.llm.last_input and any(name in app.llm.last_input for name in ("GOV.UK One Login", "Login.gov", "Singpass", "X-Road")),
            app.llm.last_input[:700],
        )
        check("grounded_answer_declares_context", "Grounded from retrieved Neo4j context." in rag.answer)
        check("grounded_answer_cites_source", "https://" in rag.answer, rag.answer)

        print("CONTEXT_SAMPLE_START")
        print(rag_context[:1200])
        print("CONTEXT_SAMPLE_END")
        print("ANSWER_START")
        print(rag.answer)
        print("ANSWER_END")
        print("VALIDATION_RESULT=PASS")
        return 0

if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"VALIDATION_RESULT=FAIL error={type(exc).__name__}: {exc}")
        raise
