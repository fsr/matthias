package firat

import (
	"log"
	"regexp"

	"github.com/abourget/slick"
)

// Firat ...
// Commands:
// !firat - Return Firat's menu
// Thanks @philipp for typing all of this!
type Firat struct{}

func init() {
	slick.RegisterPlugin(&Firat{})
}

// InitPlugin ...
func (firat *Firat) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!firat"),
		MessageHandlerFunc: firat.MenuHandler,
	})
}

// MenuHandler ...
func (firat *Firat) MenuHandler(listen *slick.Listener, msg *slick.Message) {
	log.Println("Firat menu requested by", msg.FromUser.Name)

	for _, menu := range menuParts {
		msg.ReplyPrivately(menu)
	}
}

// Sending everything at once is too much content for Slack. It's therefore split into two parts.
var menuParts = []string{
	`*Döner Gerichte*
1. *Döner* normal - 3,80€
2. *Döner* mit Käse - 4,40€
3. *Döner* mit Halloumi - 4,80€
4. *Döner Hawaii* mit Ananas - 4,50€
5. *Super Döner* mit mehr Fleisch - 4,70€
6. *Mix Döner* mit gemischtem Fleisch - 3,90€
7. *Pommdöner* mit Pommes, Fleisch und Soße - 3,50€
8. *Mais Döner* - 4,40€

*Dönerteller*
9. *Dönerteller* normal - 5,50€ 6,50€
10. *Dönerteller* mit Käse - 6,00€ 7,00€
11. *Dönerteller* mit Pommes - 5,50€ 6,50€
12. *Dönerteller* mit Halloumi - 6,50€ 7,50€
13. *Dönerteller* mit Reis - 5,50€ 6,50€
14. *Iskender* mit Joghurt, Tomatensoße und Knoblauch - 7,00€
15. *Döner-Auflauf* mit Tomatensoße und Käse überbacken - 7,00€
16. *Nudel-Döner-Auflauf* mit Tomatensoße und Käse überbacken - 6,50€

*Dürüm*
17. *Dürüm* normal - 4,10€
18. *Dürüm* mit Käse - 4,70€
19. *Dürüm* mit Halloumi - 5,00€
20. *Dürüm* mit Mais - 4,70€
21. *Dürüm Hawaii* mit Ananas - 4,70€
22. *Mix Dürüm* mit gemischtem Fleisch - 4,20€
23. *Schnitzel Dürüm* - Schnitzel im Dürüm - 4,50€
24. *Super Dürüm* - mit mehr Fleisch - 5,00€
25. *Firat Dürüm* mit gebratenem Gemüse und Halloumi - 5,00€
26. *Spinat Dürüm* - 4,70€

*Salate*
27. *Bauernsalat* - 3,50€
28. *Bauernsalat* mit Käse - 4,00€
29. *Bauernsalat* mit Käse und Oliven - 4,50€
30. *Dönersalat* mit Kalb- und Geflügelfleisch - 4,50€
31. *Italienischer Salat* mit Schinken, Ei, Käse und Thunfisch - 5,00€
32. *Thunfischsalat* - 4,50€
33. *Mazzarellasalat* mit Tomaten und Zwiebeln - 4,50€
34. *Hawaii Salat* mit Schinken, Ananas u. Käse - 4,50€

*Vegetarisches*
35. *Vegetarischer Döner* mit Salat und Soße - 3,00€
36. *Vegetarischer Döner* mit Salat, Soße u. Käse - 3,50€
37. *Vegetarischer Dürüm* mit Salat und Soße - 3,20€
38. *Vegetarischer Dürüm* mit Salat, Soße u. Käse - 3,60€
39. *Vegetarischer Dürüm* mit Salat, Soße u. Halloumi - 3,90€
40. *Falafel im Brot* mit Salat, Soße und Falafel (Kichererbsen) - 3,40€
41. *Falafel in Teigrolle* mit Salat, Soße und Falafel (Kichererbsen) - 3,80€
42. *Falafel Teller* mit Salat, Soße, Käse und Falafel (Kichererbsen) - 4,50€
43. *Vegetarischer Teller* mit Salat, Soße, Halloumi und Falafel (Kichererbsen) - 5,50€
44. *Vegetarischer Dürüm nach Art des Hauses* mit Salat, Halloumi und gebratenem Gemüse - 5,20€

*Hähnchen*
45. *1/2 Hähnchen* - 3,50€
46. *1/2 Hähnchen* mit Salat und Soße - 4,00€
47. *1/2 Hähnchen* mit Pommes - 4,00€
48. *1/2 Hähnchen* mit Pommes und Salat - 4,80€
49. *1/2 Hähnchen* mit Reis - 4,50€
50. *Chicken Chips Teller* 9 Nuggets, Pommes, Salat und Soße - 6,50€
51. *Chicken Wings Teller* 9 Hähnchenflügel gegrillt, Pommes und Soße - 6,50€
52. *Chicken Chips Tüte* 8 Nuggets - 4,00€
53. *Pommes* - 2,50€

*Schnitzel Gerichte*
54. *Schnitzel Wiener Art* - 6,00€
55. *Sahneschnitzel* mit Sahnesoße und Pilzen - 7,00€
56. *Rahmschnitzel* mit Rahmsahnesoße - 7,00€
57. *Jägerschnitzel* mit Jägersahnesoße und Pilzen - 7,00€
58. *Zigeunerschnitzel* mit Zigeunersahnesoße - 7,50€
59. *Putenschnitzel* mit Sahnesoße - 7,50€`,
	`*Nudelgerichte* (nach Wahl Spaghetti, Rigatoni oder Tortellini)
60. *Napoli* mit Tomatensoße - 4,50€
61. *Bolognese* mit Fleischsoße - 5,00€
62. *Carbonara* mit Sahnesoße, Schinken und Ei - 5,50€
63. *Brokkoli* mit Sahnesoße und Brokkoli - 5,50€
64. *Alla Chef* mit Sahnesoße, Pilzen u. Schinken - 5,50€
65. *Marinara* mit Tomatensoße, Meeresfrüchten und Knoblauch - 5,50€
66. *Gemüse* mit Sahnesoße, Pilzen, Zwiebeln und Paprika - 5,50€

*Überbackene Nudelgerichte*
67. *Spaghetti* - 6,00€
68. *Rigatoni* - 6,00€
69. *Tortellini* - 6,00€
70. *Spezial überbacken* mit Dönerfleisch, Champignons und Sahnesoße - 7,00€

*Teiggerichte* (alle mit Salat und Soße)
71. *Lahmacun* - 3,00€
72. *Lahmacun* mit Käse - 3,60€
73. *Lahmacun* mit Dönerfleisch - 4,20€
74. *Lahmacun* mit Halloumi - 4,00€
75. *Lahmacun* mit Dönerfleisch und Käse - 4,50€
76. *Pide* mit Spinat und Käse - 5,00€
77. *Pide* mit Spinat und Ei - 5,00€
78. *Pide* mit gewürztem Hackfleisch - 5,00€
79. *Pide* mit gewürztem Hackfleisch und Ei - 5,50€
80. *Pide* mit Dönerfleisch - 5,50€
81. *Pide* mit Dönerfleisch, Spinat und Halloumi - 6,00€
82. *Pide* mit Knoblauchwurst und Ei - 5,50€
83. *Börek* mit Spinat und Käse - 4,80€
84. *Börek* mit gewürztem Hackfleisch - 4,80€
85. *Börek* mit Dönerfleisch und Zwiebeln - 5,00€
86. *Sigara Börek* mit Käse und Petersilie - 3,20€

*Pizza* (alle mit Tomatensoße und Käse, ⌀ klein 24cm, ⌀ groß 29cm)
87. *Margherita* - 4,00€ 5,00€
88. *Funghi* mit Champignons - 4,50€ 5,50€
89. *Salami* - 4,50€ 5,50€
90. *Schinken* - 4,50€ 5,50€
91. *Enzo* mit Salami und Champignons - 4,80€ 5,80€
92. *Prosciutto Funghi* mit Schinken und Champignons - 4,80€ 5,80€
93. *Roma* mit Salami, Schinken und Champignons - 5,00€ 6,00€
94. *Pizza Scharf* mit Peperoniwurst, Peperoni und Zwiebeln - 4,80€ 6,00€
95. *Hawaii* mit Schinken u. Ananas -  4,80€ 6,00€
96. *Toskana* mit Salami, Schinken, Champignons, Peperoni u. Zwiebeln - 5,00€ 6,00€
97. *Bolognese* mit Fleischsoße - 4,80€ 5,50€
98. *Tonno* mit Thunfisch und Zwiebeln - 4,80€ 6,00€
99. *Calzone* (gefüllte Pizza) mit Schinken, Salami, Paprika und Champignons - 5,80€
100. *Mozzarella* mit Mozzarella, Tomaten und Zwiebeln - 4,80€ 6,00€
101. *Diavala* mit Spinat, Peperoni und Zwiebeln - 4,80€ 5,50€
102. *Halloumi* mit Halloumi, Mais und Zwiebeln - 4,80€ 6,00€
103. *Boss* mit Salami, Schinken, Champignons und Ei - 5,20€ 6,50€
104. *Vegetarisch* mit Brokkoli, Champignons, Paprika und Zwiebeln - 4,80€ 6,00€
105. *Firat* mit Knoblauchwurst, Tomaten, Champignons und Zwiebeln - 5,20€ 6,50€
106. *Döner* mit Dönerfleisch, Peperoni und Zwiebeln -5,50€ 6,50€
107. *Spezial* mit Thunfisch, Shrimps und Knoblauch - 5,50€ 6,50€
108. *Mafia* mit Schinken, Zwiebeln, Chili und Knoblauch - 5,20€ 6,50€
109. *Vier Sorten Käse* mit 4 verschiedenen Sorten Käse - 5,50€ 7,00€
110. *Vier Jahreszeiten* mit Salami, Schinken, Peperoni und Thunfisch - 5,50€ 7,00€
111. *Turbo* mit Salami, Schinken, Champignons u. Peperoni - 5,00€ 6,00€

*Suppen*
112. *Linsensuppe* - 3,00€
113. *Tomatensuppe* - 3,00€

Getränke und Extras auf firat-dresden.com`,
}
