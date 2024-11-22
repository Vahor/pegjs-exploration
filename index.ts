import { parse } from './grammar';

try {
	const input = `
companies {
	"TechCorp" {
		"context": "Cloud computing"
		keywords: [cloud, saas, enterprise]
	},
	"GreenEnergy" {
		context: "Solar panel manufacturing"
		keywords: [solar, renewable]
	}
}
-> select {
	top(3) by sentiment.highest,
	top(3) by sentiment.lowest
} 
-> fields [title, text, score]
`;


	const ast = parse(input);
	console.log(JSON.stringify(ast, null, 2));

} catch (error) {
	console.error('Error:', error);
}

