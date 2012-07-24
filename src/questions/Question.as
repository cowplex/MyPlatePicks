/**
 * @author mikelownds
 */
package questions
{
//	import Questions;
//	import Response;
	public class Question extends Questions
	{
		
		private var question     : String;
		private var category     : String;
		private var response     : Response;
		
		public function Question(question : String, category : String, response : Response)
		{
			
		}
		
		public function get category() : String
		{
			return category;
		}
		public function get response() : Response
		{
			return response;
		}
		
	}	
}