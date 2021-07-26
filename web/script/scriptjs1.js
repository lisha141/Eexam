/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
function validateData(){
   var u=document.getElementById("username").value;
   var p=document.getElementById("password").value;
   var msg='';
   if(u.length<8){ 
       msg=msg+"Username should be greater than 8 characters.";}
   if(p.length<8){
       msg=msg+"\nPassword should be greater than 8 characters.";
   }
   if(!p.match("[0-9]+")){
       msg=msg+"\nPassword should consist of atleast one numeric.";
   }
      if(msg.length>0){
          
          alert(msg);
          return false;
      }
      else{
      return true;
    
    }
}
/*function randomNumber(){
    var a=Math.floor(Math.random()*10);
    var b=Math.floor(Math.random()*10);
   document.getElementById("t1").value=a;
   document.getElementById("t2").value=b;
   document.getElementById("result").innerHTML=" ";
    document.getElementById("capcha").style.backgroundColor="white\n\
";
}

function check(){
    var a=new Number(document.getElementById("t1").value);
    var b=new Number(document.getElementById("t2").value);
    var c=new Number(document.getElementById("t3").value);
    
    var d=a+b;
    
    if(c==d){
        document.getElementById("capcha").style.backgroundColor="green";
        document.getElementById("result").innerHTML="SUCCESS";
        
    }
    else{
         document.getElementById("capcha").style.backgroundColor="red";
        document.getElementById("result").innerHTML="TRY AGAIN";
    }
}*/
 var a=new Array("7638","83tsU","W68HP","goodmorning","justexample");
            var index=0;
            function showImage(){
              
                //Generating random index
                index=Math.floor(Math.random()*a.length); //OCJP
                //Pick Image filename from array
                
                var filename="Images/"+a[index]+".png";
                
                document.getElementById("myimage").src=filename;
               
            }
            function validateImage(){      
            
                var original=a[index];
                //Pick, What user entered from text
                var entered=document.getElementById("t3").value;
                  //alert("hey "+original);
                if(original==entered)
                        //document.getElementById("form").submit();
                           document.getElementById("login").style.backgroundColor="green";
                else{
                   alert("Invalid Captcha Code. Retry");
                   document.getElementById("t3").value=" ";
            }
        }
