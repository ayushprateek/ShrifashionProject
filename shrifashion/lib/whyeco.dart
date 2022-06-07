import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/components/Font.dart';
import 'package:flutter/material.dart';
class WhyEco extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          elevation: 0.1,
          title: Text('Why Organic',style: TextStyle(fontFamily: custom_font),),

          ),
      body: SingleChildScrollView(
        child: Column(

          children: [
            Container(
              child: Image.asset('images/why.jpg'),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text:'Why Organic?\n\n',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              //decoration: TextDecoration.underline
                          ),
                         /* recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // open desired screen
                            }*/
                      ),
                      TextSpan(
                          text: 'Organic foods often have more beneficial nutrients, such as antioxidants, than their conventionally-grown counterparts and people with allergies to foods, chemicals, or preservatives may find their symptoms lessen or go away when they eat only organic foods.\n\nHow your food is grown or raised can have a major impact on your mental and emotional health as well as the environment.\n\n',
                          style: TextStyle(color: Colors.black,
                              fontSize: 15,
                              //fontWeight: FontWeight.bold
                          )
                      ),

                      TextSpan(text:'Organic produce contains fewer pesticides.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          //decoration: TextDecoration.underline
                        ),
                        /* recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // open desired screen
                            }*/
                      ),
                      TextSpan(
                          text: 'Chemicals such as synthetic fungicides, herbicides, and insecticides are widely used in conventional agriculture and residues remain on (and in) the food we eat.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),




                      TextSpan(text:'Organic food is often fresher',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          //decoration: TextDecoration.underline
                        ),
                        /* recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // open desired screen
                            }*/
                      ),
                      TextSpan(
                          text: 'because it doesn’t contain preservatives that make it last longer. Organic produce is sometimes (but not always, so watch where it is from) produced on smaller farms nearer to where it is sold.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),




                      TextSpan(text:'Organic farming tends to be better for the environment.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          //decoration: TextDecoration.underline
                        ),
                        /* recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // open desired screen
                            }*/
                      ),
                      TextSpan(
                          text: 'Organic farming practices may reduce pollution, conserve water, reduce soil erosion, increase soil fertility, and use less energy. Farming without synthetic pesticides is also better for nearby birds and animals as well as people who live close to farms.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),



                      TextSpan(text:'Organically raised animals are NOT given antibiotics, growth hormones, or fed animal byproducts.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          //decoration: TextDecoration.underline
                        ),
                        /* recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // open desired screen
                            }*/
                      ),
                      TextSpan(
                          text: 'Feeding livestock animal byproducts increases the risk of mad cow disease (BSE) and the use of antibiotics can create antibiotic-resistant strains of bacteria. Organically-raised animals tend to be given more space to move around and access to the outdoors, which help to keep them healthy.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),



                      TextSpan(text:'Organic meat and milk can be richer in certain nutrients.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          //decoration: TextDecoration.underline
                        ),
                        /* recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // open desired screen
                            }*/
                      ),
                      TextSpan(
                          text: 'Results of a 2016 European study show that levels of certain nutrients, including omega-3 fatty acids, were up to 50 percent higher in organic meat and milk than in conventionally raised versions.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),


                      TextSpan(text:'Organic food is GMO-free.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          //decoration: TextDecoration.underline
                        ),
                        /* recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // open desired screen
                            }*/
                      ),
                      TextSpan(
                          text: 'Genetically Modified Organisms (GMOs) or genetically engineered (GE) foods are plants whose DNA has been altered in ways that cannot occur in nature or in traditional crossbreeding, most commonly in order to be resistant to pesticides or produce an insecticide.\n\n',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),

                    ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}