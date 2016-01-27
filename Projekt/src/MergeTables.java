import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map.Entry;
import java.util.TreeMap;


public class MergeTables {

	public static void main(String[] args) {
		// Nastavenie suborov
		String inFCeny = "res/data_ceny.csv";
		String inFParam = "res/data_parametre.csv";
		String inFTopModely = "res/data_top.csv";
		String outFTrain = "res/train_in.csv";
		String outFTest = "res/test_in.csv";
		
		// Nacitanie dat zo suborov
		TreeMap<String, String> cenyMap = nacitajSubor(inFCeny);
		TreeMap<String, String> paramMap = nacitajSubor(inFParam);
		
		// Spojenie dat
		HashSet<DataEntry> dataset = new HashSet<DataEntry>();
		for(Iterator<Entry<String, String>> it = cenyMap.entrySet().iterator(); it.hasNext();){
			Entry<String, String> elem = it.next();
			String model = elem.getKey();
			String[] cenyArr = elem.getValue().split(";");
			String paramsData = paramMap.get(model);
			
			for(String cenaData : cenyArr){
				dataset.add(new DataEntry(model, cenaData, paramsData));
			}
		}
		
		// Rozdelenie na trenovaciu a testovaciu mnozinu
		HashSet<DataEntry> trainset = new HashSet<DataEntry>();
		HashSet<DataEntry> testset = new HashSet<DataEntry>();
		Calendar cal = Calendar.getInstance();
		cal.set(2014, 7, 31);	Date novyMobil = cal.getTime();		// 31.8.2014
		cal.set(2014, 11, 4);	Date hranicaNove = cal.getTime();	// 4.12.2014
		cal.set(2014, 9, 14);	Date hranicaStare = cal.getTime();	// 14.10.2014
		
		for(DataEntry data : dataset){
			if(data.datumVyroby.compareTo(novyMobil) > 0){
				if(data.datum.compareTo(hranicaNove) > 0){
					testset.add(data); }
				else{ trainset.add(data); }
			}
			else{
				if(data.datum.compareTo(hranicaStare) > 0){
					testset.add(data); }
				else{ trainset.add(data); }
			}
		}
		
		System.out.println("Trenovacia mnozina: " + trainset.size() + " zaznamov.");
		System.out.println("Testovacia mnozina: " + testset.size() + " zaznamov.");

		// Preskalovanie atributov podla aktualneho stavu technologii (top mobilov)
		TreeMap<String, String> topModely = nacitajSubor(inFTopModely);
		HashSet<DataEntry> trainsetScaled = new HashSet<DataEntry>();
		HashSet<DataEntry> testsetScaled = new HashSet<DataEntry>();
		for(DataEntry data : trainset){
			trainsetScaled.add(skalujData(data, topModely));
		}
		for(DataEntry data : testset){
			testsetScaled.add(skalujData(data, topModely));
		}
		
		// Zapis do suboru
		zapisSubor(outFTrain, trainsetScaled);
		zapisSubor(outFTest, testsetScaled);
		
		System.out.println("Hotovo!");
	}
	
	public static TreeMap<String, String> nacitajSubor(String subor){
		// Prvy zaznam v riadku je kluc v mape, zvysok je hodnota
		TreeMap<String, String> map = new TreeMap<String, String>();
		try {
			BufferedReader in = new BufferedReader(new FileReader(subor));
			String riadok = in.readLine();
			while(riadok != null){
				int pos = riadok.indexOf(";");
				map.put(riadok.substring(0, pos), riadok.substring(pos+1));
				riadok = in.readLine();
			}
			in.close();
		}
		catch (FileNotFoundException e) { e.printStackTrace(); }
		catch (IOException e) { e.printStackTrace(); }
		return map;
	}
	
	public static void zapisSubor(String subor, HashSet<DataEntry> dataset){
		try {
			PrintWriter out = new PrintWriter(new FileWriter(subor));
			for(DataEntry data : dataset){
				out.println(data);
			}
			out.close();
		}
		catch (IOException e) { e.printStackTrace(); }
	}

	public static DataEntry skalujData(DataEntry data, TreeMap<String, String> top){
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		Entry<String, String> skala = top.entrySet().iterator().next();
		
		// Najdenie spravneho top zaznamu na skalovanie
		for(Iterator<Entry<String, String>> it = top.entrySet().iterator(); it.hasNext();){
			Entry<String, String> topElem = it.next();
			Date topDatum = new Date();
			try{
				topDatum = dateFormat.parse(topElem.getKey());
			}
			catch (ParseException e) { e.printStackTrace(); }
		
			if(topDatum.compareTo(data.datum) > 0){
				break;
			}
			else{
				skala = topElem;
			}
		}
		
		// Preskalovanie hodnot
		DataEntry result = new DataEntry(data);
		result.params = "";
		String[] dataParams = data.params.split(";");
		String[] topParams = skala.getValue().split(";");
		for(int i = 0; i < dataParams.length; i++){
			if(i > 0){ result.params += ";"; }
			result.params += Double.parseDouble(dataParams[i]) / Double.parseDouble(topParams[i]);
		}
		
		return result;
	}
	
}