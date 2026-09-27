const fs = require("fs");
const path = require("path");

function fail(message) {
  console.error("FAIL:", message);
  process.exitCode = 1;
}

const manifestPath = "intellecto-proof-of-work/001-neo4j-certified-professional/manifest.json";
const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf8"));

if (manifest.schema_version !== "1.0") fail("Unexpected IPOW schema version");
if (manifest.id !== "IPOW-001") fail("Unexpected IPOW id");
if (!["PLANNED", "BUILD_PENDING", "IN_REVIEW", "VERIFIED", "PUBLISHED"].includes(manifest.status)) {
  fail("Invalid IPOW lifecycle status");
}
if (manifest.credential_ref !== "CERT-NEO4J-PRO-001") fail("Credential reference drift");
if (!manifest.credential_evidence || manifest.credential_evidence.verification_id !== "ed268523-3c03-434c-b269-c03c8ac41807") {
  fail("Credential evidence missing or drifted");
}
if (!Array.isArray(manifest.supporting_pow) || manifest.supporting_pow.length !== 6) {
  fail("IPOW-001 must reference exactly six Neo4j PoWs");
}

const expected = [
  ["POW-NEO4J-001", "neo4j/01-enterprise-architecture-knowledge-graph", "c9a08859be1e83ea265ac1b6d4a0d2785e00bc53"],
  ["POW-NEO4J-002", "neo4j/01-enterprise-architecture-knowledge-graph", "994bb250380a9d2b5b278d45edba1f6aca621db5"],
  ["POW-NEO4J-003", "neo4j/03-global-govtech-graph-data-modeling", "0a94ab182bdad4cd98841e72cd2296083a0bf9f4"],
  ["POW-NEO4J-004", "neo4j/04-global-govtech-data-import-pipeline", "b9bd10706f61f2d5a9aa0854bde2c619dd71766f"],
  ["POW-NEO4J-005", "neo4j/05-global-govtech-python-driver", "683dcd995f291c59bec438bef7a07cd3df60ced2"],
  ["POW-NEO4J-006", "neo4j/06-global-govtech-graphrag-grounded-retrieval", "b9fa1de8824d0e935e0cfa4e7969e91040677223"]
];

for (const [id, expectedPath, commit] of expected) {
  const item = manifest.supporting_pow.find(x => x.id === id);
  if (!item) {
    fail("Missing supporting evidence " + id);
    continue;
  }
  if (item.path !== expectedPath) fail(id + " path drift");
  if (item.immutable_commit !== commit) fail(id + " immutable commit drift");
  if (!fs.existsSync(path.join(expectedPath, "README.md"))) fail(id + " public README missing");
}

for (const required of ["README.md", "EVIDENCE-MAP.md", "CLAIMS.md", "manifest.json"]) {
  const full = path.join("intellecto-proof-of-work/001-neo4j-certified-professional", required);
  if (!fs.existsSync(full)) fail("Missing required IPOW file " + required);
}

if (!manifest.claims_boundary) fail("Claims boundary missing");
if (manifest.privacy !== "PUBLIC_SAFE") fail("Unexpected privacy classification");

if (manifest.status === "VERIFIED" || manifest.status === "PUBLISHED") {
  if (!manifest.immutable_commit) fail("Verified/published IPOW requires immutable_commit");
}

if (!process.exitCode) {
  console.log("PASS ipow_id=IPOW-001");
  console.log("PASS credential_ref=CERT-NEO4J-PRO-001");
  console.log("PASS supporting_pow=6");
  console.log("PASS public_paths_resolve=true");
  console.log("PASS claims_boundary=true");
  console.log("PASS privacy=PUBLIC_SAFE");
  console.log("PASS lifecycle=" + manifest.status);
  console.log("IPOW_VALIDATION_RESULT=PASS");
}
