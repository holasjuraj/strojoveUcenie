import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.TimeUnit;

public class DataEntry {
	public String model;
	public Date datum;
	public Date datumVyroby;
	public String params;
	public String minCena;
	public String avgCena;
	private static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
	
	public DataEntry(String model, String cenaData, String paramsData){
		
		this.model = model;
		
		// Parsovanie udajov o cene
		String[] cenaDataArr = cenaData.split("-");
		try {
			datum = dateFormat.parse(cenaDataArr[0]);
		} catch (ParseException e) {
			datum = new Date();
		}
		minCena = cenaDataArr[1];
		avgCena = cenaDataArr[2];
		
		// Parsovanie parametrov
		int pos = paramsData.indexOf(";");
		try {
			datumVyroby = dateFormat.parse(paramsData.substring(0, pos));
		} catch (ParseException e) {
			datumVyroby = new Date();
		}
		params = paramsData.substring(pos+1);
	}
	
	public DataEntry(DataEntry data){
		this.model = data.model;
		this.datum = data.datum;
		this.datumVyroby = data.datumVyroby;
		this.params = data.params;
		this.minCena = data.minCena;
		this.avgCena = data.avgCena;
	}

	@Override
	public String toString() {
		return	prevedDatum(datum) +";"+
				prevedDatum(datumVyroby) +";"+
				params +";"+
				minCena +";"+
				avgCena;
	}
	
	private String prevedDatum(Date datum){
		// Prevod na pocet dni od 1.1.2010
		String zaklad = "20100101";
		try {
		    long rozdiel = datum.getTime() - dateFormat.parse(zaklad).getTime();
		    return "" + TimeUnit.DAYS.convert(rozdiel, TimeUnit.MILLISECONDS);
		}
		catch (ParseException e) { e.printStackTrace(); }
		return "0";
	}
		
}