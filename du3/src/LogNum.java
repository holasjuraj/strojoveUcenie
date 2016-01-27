
public class LogNum {
	
	private double logx = 0;
	private boolean isZero = false;
	
	public LogNum(double x){
		if(x <= 0){
			isZero = true;
		}else{
			logx = Math.log(x);
		}
	}
	public LogNum(){
		this(0);
	}
	
	public static LogNum mul(LogNum a, LogNum b){
		LogNum result = new LogNum();
		result.isZero = a.isZero || b.isZero;
		result.logx = a.logx + b.logx;
		return result;
	}
	public static LogNum mul(double a, LogNum b){
		return mul(new LogNum(a), b);
	}
	public static LogNum mul(LogNum a, LogNum b, LogNum c){
		return mul(mul(a, b), c);
	}
	
	public boolean isGt(LogNum b){
		return !isZero && logx > b.logx;
	}

}
