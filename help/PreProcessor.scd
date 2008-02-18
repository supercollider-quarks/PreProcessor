this.preProcessor = PreProcessor.new;


(
// a little pseudo-lisp language with no syntax safety nets.
// not guaranteed to work in all cases.
e = (
	lang: \lisp,
	languages:
		(
		lisp: // code is the incoming string, event is the event for parameters and output
			{|code, event| 			
			var stack, op, mem, res, res2, char, i = 0, j = 0, selector;
			
			// some cleanup
			// guarantee blanks after parentheses
			code = 
				code	.replace("( ", "(")
					.replace("(", "( ")
					.replace(" )", ")")
					.replace(")", " )")
					.replace("  ", " ");			
			
			while { i.notNil and: { i < code.size }} {
				char = code[i];
				switch(char,
						$(, /*)*/ 
						{
							
							mem !? { stack = stack.add(mem) };
							j = code.find(" ", offset: i);
							i = code.find(" ", offset: j + 1);
							mem = List.new;
							mem.add(code[j..i - 1].replace(" ", "").asSymbol);
							j = i;
							
							
							
						},
						/*(*/ 
						$), {
								if(mem.notEmpty) {
									res2 = mem[1..].reduce(mem[0]);
									mem = stack.pop;
									res !? { mem.add(res2) };
								};
								i = i + 1;
								j = i;
						},
						$ , {
									res = code[j..i].interpret;
									res !? { mem = mem.add(res) };
									j = i;
									i = i + 1;
						}, 
						{
									i = i + 1;
						}
				);
			};
				
				event.put(\result, res2)
			}
		)
);
);

(
e = <%   (+ 4 3 ( + 2 3 ) (/ 10 2))    %>.value(e); // 4 + 3 + (2 + 3) + (10 / 2)
e.result;
)

// remove preprocessor

this.preProcessor = nil;
