import { filterPipeline } from "rdffilter"
import { Quad, NamedNode } from "n3"

class URIMap {
  constructor(map) {
    this.map = {}
    for (let key in map) {
      this.map[key] = new NamedNode(map[key])
    }
  }

  filterTriple(triple) {
    const predicate = this.map[triple.predicate.value]
    return predicate ? new Quad(triple.subject, predicate, triple.object) : true
  }
}

const predicateMap = new URIMap({
  "http://www.wikidata.org/prop/direct/P856": "http://xmlns.com/foaf/0.1/homepage",
  "http://www.wikidata.org/prop/direct/P98": "http://purl.org/dc/terms/publisher",
})

export default filterPipeline([
  // We are only interested in simple statements about the entity
  ({subject}) => subject.termType == "NamedNode" && subject.value.startsWith("http://www.wikidata.org/entity/"),
  // map Wikidata ontology to preferred predicates
  triple => predicateMap.filterTriple(triple),
])
