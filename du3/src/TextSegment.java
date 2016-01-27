import java.io.BufferedReader;
import java.io.FileReader;
import java.text.DecimalFormat;

public class TextSegment {

	public static void main(String[] args) {
		TextSegment ts = new TextSegment();
		System.out.println("Test sk-en-100:");
		ts.train("res/sk-en-100-train.txt");
		ts.test("res/sk-en-100-test.txt");

		System.out.println("\nTest sk-en-1000:");
		ts.train("res/sk-en-1000-train.txt");
		ts.test("res/sk-en-1000-test.txt");

		System.out.println("\nTest sk-cs-100:");
		ts.train("res/sk-cs-100-train.txt");
		ts.test("res/sk-cs-100-test.txt");

		System.out.println("\nTest sk-cs-1000:");
		ts.train("res/sk-cs-1000-train.txt");
		ts.test("res/sk-cs-1000-test.txt");
	}
	

	char lang1, lang2;
	LogNum[][] t;
	LogNum[][] e;
	
	private int cToIndex(char c){
		if(c == ' '){ return 0; }
		c = Character.toLowerCase(c);
		return c - 'a' + 1;
	}
	
	public void train(String trainFile){
		lang1 = '#';
		lang2 = '#';
		t = new LogNum[2][2];
		e = new LogNum[2][27];
		String chars = "", langs = "";
		try {
			BufferedReader in = new BufferedReader(new FileReader(trainFile));
			chars = in.readLine();
			langs = in.readLine();
			in.close();
		}
		catch (Exception e) { e.printStackTrace(); }
		
		double  l1count = 0, l2count = 0,   // Pocet pismen v jazyku 1/2
				change12 = 0, change21 = 0; // Pocet zmien jazyka 1->2 / 2->1
		double[] c1count = new double[27],  // Pocty jednotlivych pismen v jazyku 1
				 c2count = new double[27];  // Pocty jednotlivych pismen v jazyku 2
		lang1 = langs.charAt(0);
		char lastLang = lang1;

		// Pocitanie pismen, vyskytov jazyka, zmien jazyka
		for(int i = 0; i < chars.length(); i++){
			char c = chars.charAt(i),
				 l = langs.charAt(i);
			
			if(l == lang1){
				l1count++;
				if(lastLang == lang2){ change21++; }
				c1count[cToIndex(c)]++;
			}
			else{
				if(lang2 == '#'){ lang2 = l; }
				l2count++;
				if(lastLang == lang1){ change12++; }
				c2count[cToIndex(c)]++;
			}
			
			lastLang = l;
		}
		
		// Pocitanie emisnych pravdepodobnosti
		for(int i = 0; i < 27; i++){
			e[0][i] = new LogNum(c1count[i] / l1count);
			e[1][i] = new LogNum(c2count[i] / l2count);
		}
		
		// Pocitanie prechodovych frekvencii
		t[0][0] = new LogNum((l1count - change12) / l1count);
		t[0][1] = new LogNum(change12 / l1count);
		t[1][1] = new LogNum((l2count - change21) / l2count);
		t[1][0] = new LogNum(change21 / l2count);
	}
	
	public String viterbi(String chars){
		// Pomocna struktura pre dyn. prog.
		class field{
			LogNum p = new LogNum(); // Pravdepodobnost
			int from = 0;            // Predchadzajuce policko
			public field(){}
			public field(LogNum p, int from){
				this.p = p;
				this.from = from;
			}
		};
		
		// Viterbiho algoritmus
		field[][] A = new field[chars.length()][2];
		A[0][0] = new field(LogNum.mul(0.5 , e[0][cToIndex(chars.charAt(0))]), -1);
		A[0][1] = new field(LogNum.mul(0.5 , e[1][cToIndex(chars.charAt(0))]), -1);
		
		for(int i = 1; i < chars.length(); i++){
			char c = chars.charAt(i);
			for(int j = 0; j < 2; j++){
				LogNum
					p0 = LogNum.mul(A[i-1][0].p , t[0][j] , e[j][cToIndex(c)]),
					p1 = LogNum.mul(A[i-1][1].p , t[1][j] , e[j][cToIndex(c)]);
				A[i][j] = new field();
				if(p0.isGt(p1)){
					A[i][j].p = p0;
					A[i][j].from = 0;
				}
				else{
					A[i][j].p = p1;
					A[i][j].from = 1;
				}
			}
		}
		
		// Rekonstrukcia cesty
		StringBuilder sb = new StringBuilder();
		int from = 0;
		if(A[A.length-1][1].p.isGt(A[A.length-1][0].p)){
			from = 1;
		}
		for(int i = A.length-1; i >= 0; i--){
			if(from == 0){
				sb.append(lang1);
			}else{
				sb.append(lang2);
			}
			from = A[i][from].from;
		}
		return sb.reverse().toString();		
	}
	
	public void test(String testFile){
		String chars = "", langs = "";
		try {
			BufferedReader in = new BufferedReader(new FileReader(testFile));
			chars = in.readLine();
			langs = in.readLine();
			in.close();
		}
		catch (Exception e) { e.printStackTrace(); }
		
		// Spustenie Viterbiho algoritmu
		String guess = viterbi(chars);
		
		// Vyhodnotenie uspesnosti
		int goodGuess = 0;
		for(int i = 0; i < langs.length(); i++){
			if(langs.charAt(i) == guess.charAt(i)){
				goodGuess++;
			}
		}
		System.out.println(new DecimalFormat("Spravne urcenych #0.000% znakov").format((double)goodGuess / langs.length()));
	}

}
