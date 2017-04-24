`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: Reshma Raghavan
// 
// Create Date:    15:51:04 06/21/2015 
// Design Name:    project2
// Module Name:    project2 
// Project Name:   Guessing Game
// Target Devices: Digilent Basys 2
// Tool versions:  ISE Version 14.7(nt64)
// 
//////////////////////////////////////////////////////////////////////////////////
module project2( switch,btn,clk,anode,seg,led,switch4,switch5);

    input [3:0] switch;//for players  to enter the numbers
	 
	 /*switch4's high-low from low indicates a guess while
	 switch5's high from low indicates player 2's turn*/
	 input switch4,switch5;
	 
    input [3:0] btn;//for the push buttons
    input clk;//for the built in clock
	 output [3:0] anode;
    output [7:0] seg;//for the 7 segment display
	 output [3:0] led;//leds corresponding to switches 3:0
    reg [7:0] seg0;//corresponding to anode 0
    reg [7:0] seg1;//corresponding to anode 1
    reg [7:0] seg2;//corresponding to anode 2
    reg [7:0] seg3;//corresponding to anode 3
    reg [3:0] anode;
    reg [7:0] seg;
	 reg [3:0] led;
	 reg [3:0] cnt=4'b 0000;//counts no of guesses. Max assumed to be 15.
	 
	 /*created for slowing the built-in clock to 
	 strobe the numbers onto the 7 segment display*/
	 reg slow_clock;
	 
	 /* count - used for slowing the built in clock for
	 blinking the leds
	 no - number entered by player 1
	 guess - guess made by player 2
	 flag=1 for correct guess
	 fbtn - flag for clearing the buttons during player1's turn
	 fbtn1 - flag for clearing the buttons during player2's turn
	 state/state1 = 0 when guess is not yet made
	 state/state1 = 2 when the guess has been made
	 lhflag - flag used to clear out pl2 while making a string of guesses
	 sw4 - increased when switch 4 is pressed */
	 
    integer count,no,guess,flag=0;
	 integer fbtn1=0,sw4=0,state=0,state1=0,lhflag=0;
	 integer fbtn=0;
	
	 //on posedge clk
    always @(posedge clk)
	 begin
      create_slow_clock(clk, slow_clock);//slows clk
	   if (flag==1)//for led blinking
	   begin
	      if (count > 5000000)//slows clk
         begin
           count=0;
           led= ~ led;
         end//slows clk
      count = count+1;
      end//for led blinking
	 end//on posedge clk
	 
	 //on posedge slow_clock
	 always @(posedge slow_clock)
    begin
	   //for strobing the nos onto the 7 segment displays
	   case(anode)
        4'b 1110: anode=4'b 1101;
        4'b 1101: anode=4'b 1011;
        4'b 1011: anode=4'b 0111;
	     4'b 0111: anode=4'b 1110;
	     default: anode = 4'b 1110;
      endcase
	   case (anode)
	     4'b 1110: seg=seg0;
        4'b 1101: seg=seg1;
        4'b 1011: seg=seg2;
	     4'b 0111: seg=seg3;
	   endcase//for strobing the nos onto the 7 segment displays
		
	   //Player 1's turn
	   if ((switch5 == 0)&&(sw4==0))
	   begin
	       no=switch;
	       //a button is pressed
	       case(btn)
	       4'b1000: 
	       begin
	         fbtn=fbtn+1;
	         no=switch;
	         seg3=cathode(switch);
	         //initially clears other 7 segments
	         if(fbtn==1)
	         begin
	           seg0=8'b11111111;
	           seg1=8'b11111111;
	           seg2=8'b11111111;
	         end
	       end
          4'b0100: 
	       begin
	         fbtn=fbtn+1;
	         no=switch;
	         seg2=cathode(switch);
	         //initially clears other 7 segments
	           if(fbtn==1)
	           begin
	           seg0=8'b11111111;
	           seg1=8'b11111111;
	           seg3=8'b11111111;
	           end
          end
          4'b0010: 
	       begin
	         fbtn=fbtn+1;
	         no=switch;
	         seg1=cathode(switch);
	         //initially clears other 7 segments
	         if(fbtn==1)
	         begin
	           seg0=8'b11111111;
	           seg3=8'b11111111;
	           seg2=8'b11111111;
	         end
          end
          4'b0001: 
	       begin
	         fbtn=fbtn+1;
	         no=switch;
	         seg0=cathode(switch);
	         //initially clears other 7 segments
	         if(fbtn==1)
	         begin
	           seg3=8'b11111111;
	           seg1=8'b11111111;
	           seg2=8'b11111111;
	         end
	       end
	       default://displays pl1 until a button is pressed
	       begin
	         if((btn==4'b0000)&&(fbtn==0))
	         begin
	           seg0=8'b 11111001;
	           seg1=8'b 11000111;
	           seg2=8'b 10001100;
	           seg3=8'b 11111111;
	         end
	       end
          endcase//a button is pressed
	  end//Player 1's turn
	  
	  
	  //player 2's turn
	  else if ((switch5==1)&&(sw4==0)&&(state1==0))
	  begin
	    //a button is pressed
	    case(btn)
	    4'b1000: 
	    begin
	    fbtn1=fbtn1+1;
	    seg3=cathode(switch);
	      //initially clears other 7 segments
	      if(fbtn1==1)
	      begin
	        seg0=8'b11111111;
	        seg1=8'b11111111;
	        seg2=8'b11111111;
	      end
	    end
       4'b0100: 
	    begin
	    fbtn1=fbtn1+1;
	    seg2=cathode(switch);
	    //initially clears other 7 segments
	      if(fbtn1==1)
	      begin
	        seg0=8'b11111111;
	        seg1=8'b11111111;
	        seg3=8'b11111111;
	      end
         end
       4'b0010: 
	    begin
	    fbtn1=fbtn1+1;
	    seg1=cathode(switch);
	    //initially clears other 7 segments
	      if(fbtn1==1)
	      begin
	        seg0=8'b11111111;
	        seg3=8'b11111111;
	        seg2=8'b11111111;
	      end
       end
       4'b0001: 
	    begin
	    fbtn1=fbtn1+1;
	    seg0=cathode(switch);
	    //initially clears other 7 segments
	      if(fbtn1==1)
	      begin
	        seg3=8'b11111111;
	        seg1=8'b11111111;
	        seg2=8'b11111111;
	      end
	    end
	    //displays pl1 until a button is pressed and if a guess isn't already made
	    default:
	    begin
	      if((btn==4'b0000)&&(fbtn1==0)&&(lhflag==0))
	      begin
	        seg0=8'b 10100100;
	        seg1=8'b 11000111;
	        seg2=8'b 10001100;
	        seg3=8'b 11111111;
	      end
	    end//displays pl1 until a button is pressed and if a guess isn't already made
       endcase//a button is pressed
	    //start of a guess
	    //switch4's low-high
	    if (switch4==1)
	    begin
	      state=2;
	      sw4=sw4+1;
	      state1=2;
	    end//switch4's low-high
	  end//player 2's turn
	  
	  
	  //switch4's high-low - guess is made
	  if ((switch4==0)&&(state==2))
	  begin
	    if (sw4==1)//if switch4 was low-high
	    begin
	      guess=switch;
		   cnt=cnt+1;//increasing the guess count
		 
		   if (guess==no)//correct guess
		   begin
		     flag=1;
		     seg0=cathode(cnt);
		     seg3=8'b11111111;
	        seg1=8'b11111111;
	        seg2=8'b11111111;
		     state1=3;//end of game
		     sw4=2;//end of game
		     state=0;//exits if
		   end//correct game
		
		   else if(guess>no)//high guess
		   begin
		     seg0=8'b 11111001;
		     seg1=8'b 10001001;
		     seg2=8'b 10100100;
		     seg3=8'b 11111111;
		     sw4=0;//back to player 2's turn
		     state1=0;//back to player 2's turn
		     lhflag=1;//a guess is made
		     state=0;//exits else if
		   end//high guess
		
		   else if(guess<no)//low guess
		   begin
		     seg0=8'b 11000000;
		     seg1=8'b 11000111;
		     seg2=8'b 10100100;
		     seg3=8'b 11111111;
		     sw4=0;//back to player 2's turn
		     state1=0;//back to player 2's turn
		     lhflag=1;//a guess is made
		     state=0;//exits else if
		   end//low guess
		 
	    end//if switch4 was low-high
	  end//switch4's high-low - guess is made
	end//on posedge slow_clock
	
	 //slows clk
	 task create_slow_clock;
      input clock;
      inout slow_clock;
      integer cunt;
      begin
        if (cunt > 25000)
        begin
          cunt=0;
          slow_clock = ~slow_clock;
        end
      cunt = cunt+1;
      end
    endtask//slows clk
	 
	 //decoding the switches/cnt onto the 7 segment display
	 function [7:0] cathode;
     input [3:0] switch;
     begin
       case (switch)
	    0: cathode = 8'b 11000000;
       1: cathode = 8'b 11111001;
       2: cathode = 8'b 10100100;
	    3: cathode = 8'b 10110000;
	    4: cathode = 8'b 10011001;
	    5: cathode = 8'b 10010010;
	    6: cathode = 8'b 10000010;
	    7: cathode = 8'b 11111000;
	    8: cathode = 8'b 10000000;
	    9: cathode = 8'b 10010000;
	   10: cathode = 8'b 10001000;
	   11: cathode = 8'b 10000011;
	   12: cathode = 8'b 11000110;
	   13: cathode = 8'b 10100001;
	   14: cathode = 8'b 10000110;
	   15: cathode = 8'b 10001110;
      endcase
	  end
   endfunction//decoding the switches/cnt onto the 7 segment display
	
	endmodule
	//EOF

	
	
	