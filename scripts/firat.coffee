# Description:
#   Mensa Firat
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot firat
#
# Author:
#   philipp

module.exports = (robot) ->
	robot.respond /firat/i, (msg) ->
 	  msg.send("*Döner Gerichte*\n
1. *Döner* normal - 3,80€\n
2. *Döner* mit Käse - 4,40€\n
3. *Döner* mit Halloumi - 4,80€\n
4. *Döner Hawaii* mit Ananas - 4,50€\n
5. *Super Döner* mit mehr Fleisch - 4,70€\n
6. *Mix Döner* mit gemischtem Fleisch - 3,90€\n
7. *Pommdöner* mit Pommes, Fleisch und Soße - 3,50€\n
8. *Mais Döner* - 4,40€\n
\n
*Dönerteller*\n
9. *Dönerteller* normal - 5,50€ 6,50€\n
10. *Dönerteller* mit Käse - 6,00€ 7,00€\n
11. *Dönerteller* mit Pommes - 5,50€ 6,50€\n
12. *Dönerteller* mit Halloumi - 6,50€ 7,50€\n
13. *Dönerteller* mit Reis - 5,50€ 6,50€\n
14. *Iskender* mit Joghurt, Tomatensoße und Knoblauch - 7,00€\n
15. *Döner-Auflauf* mit Tomatensoße und Käse überbacken - 7,00€\n
16. *Nudel-Döner-Auflauf* mit Tomatensoße und Käse überbacken - 6,50€\n
\n
*Dürüm*\n
17. *Dürüm* normal - 4,10€\n
18. *Dürüm* mit Käse - 4,70€\n
19. *Dürüm* mit Halloumi - 5,00€\n
20. *Dürüm* mit Mais - 4,70€\n
21. *Dürüm Hawaii* mit Ananas - 4,70€\n
22. *Mix Dürüm* mit gemischtem Fleisch - 4,20€\n
23. *Schnitzel Dürüm* - Schnitzel im Dürüm - 4,50€\n
24. *Super Dürüm* - mit mehr Fleisch - 5,00€\n
25. *Firat Dürüm* mit gebratenem Gemüse und Halloumi - 5,00€\n
26. *Spinat Dürüm* - 4,70€\n
\n
*Salate*\n
27. *Bauernsalat* - 3,50€\n
28. *Bauernsalat* mit Käse - 4,00€\n
29. *Bauernsalat* mit Käse und Oliven - 4,50€\n
30. *Dönersalat* mit Kalb- und Geflügelfleisch - 4,50€\n
31. *Italienischer Salat* mit Schinken, Ei, Käse und Thunfisch - 5,00€\n
32. *Thunfischsalat* - 4,50€\n
33. *Mazzarellasalat* mit Tomaten und Zwiebeln - 4,50€\n
34. *Hawaii Salat* mit Schinken, Ananas u. Käse - 4,50€\n
\n
*Vegetarisches*\n
35. *Vegetarischer Döner* mit Salat und Soße - 3,00€\n
36. *Vegetarischer Döner* mit Salat, Soße u. Käse - 3,50€\n
37. *Vegetarischer Dürüm* mit Salat und Soße - 3,20€\n
38. *Vegetarischer Dürüm* mit Salat, Soße u. Käse - 3,60€\n
39. *Vegetarischer Dürüm* mit Salat, Soße u. Halloumi - 3,90€\n
40. *Falafel im Brot* mit Salat, Soße und Falafel (Kichererbsen) - 3,40€\n
41. *Falafel in Teigrolle* mit Salat, Soße und Falafel (Kichererbsen) - 3,80€\n
42. *Falafel Teller* mit Salat, Soße, Käse und Falafel (Kichererbsen) - 4,50€\n
43. *Vegetarischer Teller* mit Salat, Soße, Halloumi und Falafel (Kichererbsen) - 5,50€\n
44. *Vegetarischer Dürüm nach Art des Hauses* mit Salat, Halloumi und gebratenem Gemüse - 5,20€\n
\n\n
*Hähnchen*\n
45. *1/2 Hähnchen* - 3,50€\n
46. *1/2 Hähnchen* mit Salat und Soße - 4,00€\n
47. *1/2 Hähnchen* mit Pommes - 4,00€\n
48. *1/2 Hähnchen* mit Pommes und Salat - 4,80€\n
49. *1/2 Hähnchen* mit Reis - 4,50€\n
50. *Chicken Chips Teller* 9 Nuggets, Pommes, Salat und Soße - 6,50€\n
51. *Chicken Wings Teller* 9 Hähnchenflügel gegrillt, Pommes und Soße - 6,50€\n
52. *Chicken Chips Tüte* 8 Nuggets - 4,00€\n
53. *Pommes* - 2,50€\n
\n
*Schnitzel Gerichte*\n
54. *Schnitzel Wiener Art* - 6,00€\n
55. *Sahneschnitzel* mit Sahnesoße und Pilzen - 7,00€\n
56. *Rahmschnitzel* mit Rahmsahnesoße - 7,00€\n
57. *Jägerschnitzel* mit Jägersahnesoße und Pilzen - 7,00€\n
58. *Zigeunerschnitzel* mit Zigeunersahnesoße - 7,50€\n
59. *Putenschnitzel* mit Sahnesoße - 7,50€")

    msg.send("*Nudelgerichte* (nach Wahl Spaghetti, Rigatoni oder Tortellini)\n
60. *Napoli* mit Tomatensoße - 4,50€\n
61. *Bolognese* mit Fleischsoße - 5,00€\n
62. *Carbonara* mit Sahnesoße, Schinken und Ei - 5,50€\n
63. *Brokkoli* mit Sahnesoße und Brokkoli - 5,50€\n
64. *Alla Chef* mit Sahnesoße, Pilzen u. Schinken - 5,50€\n
65. *Marinara* mit Tomatensoße, Meeresfrüchten und Knoblauch - 5,50€\n
66. *Gemüse* mit Sahnesoße, Pilzen, Zwiebeln und Paprika - 5,50€\n
\n
*Überbackene Nudelgerichte*\n
67. *Spaghetti* - 6,00€\n
68. *Rigatoni* - 6,00€\n
69. *Tortellini* - 6,00€\n
70. *Spezial überbacken* mit Dönerfleisch, Champignons und Sahnesoße - 7,00€\n
\n
*Teiggerichte* (alle mit Salat und Soße)\n
71. *Lahmacun* - 3,00€\n
72. *Lahmacun* mit Käse - 3,60€\n
73. *Lahmacun* mit Dönerfleisch - 4,20€\n
74. *Lahmacun* mit Halloumi - 4,00€\n
75. *Lahmacun* mit Dönerfleisch und Käse - 4,50€\n
76. *Pide* mit Spinat und Käse - 5,00€\n
77. *Pide* mit Spinat und Ei - 5,00€\n
78. *Pide* mit gewürztem Hackfleisch - 5,00€\n
79. *Pide* mit gewürztem Hackfleisch und Ei - 5,50€\n
80. *Pide* mit Dönerfleisch - 5,50€\n
81. *Pide* mit Dönerfleisch, Spinat und Halloumi - 6,00€\n
82. *Pide* mit Knoblauchwurst und Ei - 5,50€\n
83. *Börek* mit Spinat und Käse - 4,80€\n
84. *Börek* mit gewürztem Hackfleisch - 4,80€\n
85. *Börek* mit Dönerfleisch und Zwiebeln - 5,00€\n
86. *Sigara Börek* mit Käse und Petersilie - 3,20€\n
\n
*Pizza* (alle mit Tomatensoße und Käse, ⌀ klein 24cm, ⌀ groß 29cm)\n
87. *Margherita* - 4,00€ 5,00€\n
88. *Funghi* mit Champignons - 4,50€ 5,50€\n
89. *Salami* - 4,50€ 5,50€\n
90. *Schinken* - 4,50€ 5,50€\n
91. *Enzo* mit Salami und Champignons - 4,80€ 5,80€\n
92. *Prosciutto Funghi* mit Schinken und Champignons - 4,80€ 5,80€\n
93. *Roma* mit Salami, Schinken und Champignons - 5,00€ 6,00€\n
94. *Pizza Scharf* mit Peperoniwurst, Peperoni und Zwiebeln - 4,80€ 6,00€\n
95. *Hawaii* mit Schinken u. Ananas -  4,80€ 6,00€\n
96. *Toskana* mit Salami, Schinken, Champignons, Peperoni u. Zwiebeln - 5,00€ 6,00€\n
97. *Bolognese* mit Fleischsoße - 4,80€ 5,50€\n
98. *Tonno* mit Thunfisch und Zwiebeln - 4,80€ 6,00€\n
99. *Calzone* (gefüllte Pizza) mit Schinken, Salami, Paprika und Champignons - 5,80€\n
100. *Mozzarella* mit Mozzarella, Tomaten und Zwiebeln - 4,80€ 6,00€\n
101. *Diavala* mit Spinat, Peperoni und Zwiebeln - 4,80€ 5,50€\n
102. *Halloumi* mit Halloumi, Mais und Zwiebeln - 4,80€ 6,00€\n
103. *Boss* mit Salami, Schinken, Champignons und Ei - 5,20€ 6,50€\n
104. *Vegetarisch* mit Brokkoli, Champignons, Paprika und Zwiebeln - 4,80€ 6,00€\n
105. *Firat* mit Knoblauchwurst, Tomaten, Champignons und Zwiebeln - 5,20€ 6,50€\n
106. *Döner* mit Dönerfleisch, Peperoni und Zwiebeln -5,50€ 6,50€\n
107. *Spezial* mit Thunfisch, Shrimps und Knoblauch - 5,50€ 6,50€\n
108. *Mafia* mit Schinken, Zwiebeln, Chili und Knoblauch - 5,20€ 6,50€\n
109. *Vier Sorten Käse* mit 4 verschiedenen Sorten Käse - 5,50€ 7,00€\n
110. *Vier Jahreszeiten* mit Salami, Schinken, Peperoni und Thunfisch - 5,50€ 7,00€\n
111. *Turbo* mit Salami, Schinken, Champignons u. Peperoni - 5,00€ 6,00€\n
\n
*Suppen*\n
112. *Linsensuppe* - 3,00€\n
113. *Tomatensuppe* - 3,00€\n
\n
Getränke und Extras auf firat-dresden.com")
