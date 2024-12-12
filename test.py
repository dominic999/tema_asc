rez = input("rezolvare: ")
test = input("test: ")
fileRez = open(rez, "r")
fileTest = open(test, "r")
linesRez = fileRez.readlines()
linesTest = fileTest.readlines()
for i in range(len(linesTest)): #range(len(linesTest)):
    for j in range(len(linesRez[i])):
        if(linesRez[i][j] != linesTest[i][j]):
            print("eroare lina: " + str(i))
            print("output: " + linesTest[i])
            print("expected: " + linesRez[i])
            print("diferenta este: " + linesRez[i][j]  + " " + linesTest[i][j])
            print("final")
    x = i

# for i in range(x, len(linesTest)):
#         print("uite: " + " " + str(i) + " " + linesTest[i])
