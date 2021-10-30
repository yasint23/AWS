def isValid(s):
  bracket_map = {"(": ")", "[": "]",  "{": "}"}
  open_par = set(["(", "[", "{"])
  stack = []
  for i in s:
    if i in open_par:
        stack.append(i)
    elif stack and i == bracket_map[stack[-1]]:
        stack.pop()
    else:
        return False
  return stack == []

combination = input('Write a string that contains only `(`, `)`, `{`, `}`, `[` and `]`: ')
print(isValid(combination))




def isValid(s) :
    while "()" in s or "{}" in s or "[]" in s:
        s = s.replace("()", "").replace("[]", "").replace("{}", "")
    return s == ""

   