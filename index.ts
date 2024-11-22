import { parse } from './grammar';

try {
	const input = `
  companies {
    "EmptyCompany" {
      keywords: []
      context: "It's empty"
    }
    "TechCorp" {
      keywords: ["cloud", "saas", "enterprise"]
      context: "Cloud computing"
    }
    "GreenEnergy" {
      context: "Solar panel manufacturing"
      keywords: ["solar", "renewable"]
    }
  }
-> select {
  top(3) by negative.ASC
  top(4) by positive.ASC
}
-> fields [title, score]
`;


	const ast = parse(input);
	console.log(JSON.stringify(ast, null, 2));
	const companiesKeys = ast.companies.map((company) => company._key);
	console.log(companiesKeys);

} catch (error) {
	console.error('Error:', error);
}

