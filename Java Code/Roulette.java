import java.util.*;

class Roulette{
    public static void main(String[] args) {
        
        int repetitions = 10;         //how often to repeat the whole calculation
        int reps_won = 0;
        for(int rep=0;rep<repetitions;rep++) {     //repeat all
        int house_nums = 1;             //number of 0 fields
        int days = 10;                   //number of days in the casino
        int maxgamespd = 25;        //maximum number of games per day
        int firstsavings = 100;         //money to start out with
        int savings = firstsavings;
        int number_pockets = 37;
        int casino_pockets = 1;
        int probability = 2;            //the actual probability is 1/probability disregarding the 0 field
        int firstbet = 1;               //how much do you bet?
        int bet = firstbet;             
        int profit = 0;
        int maxprofit = 320;            //maximum profit in one day
        int maxloss = 320;              //maximum loss in one day
        int win = 0;
        int profit_round = 0;
        int times_won = 0;
        int times_lost = 0;
        Random random = new Random();

        System.out.println("Ihr Geld vorm Casinobesuch: " + savings + "   Tage im Casino: " + days + "   Einsatz pro Spiel: " + bet);
        outer:
        for(int ii=0;ii<days;ii++) {
            int todayfirstsavings = savings;
            bet = firstbet;
            for(int i=0;i<maxgamespd;i++) {
                int todaybet = bet;
                int number = random.nextInt(36+house_nums);
                win = ((36 / probability)+house_nums < number+1 ) ? 1 : 0; 
                savings -= bet;
                if (win == 1) {
                    times_won += 1;      //count wins
                    savings += bet * probability; 
                    profit_round = bet;
                    bet = firstbet;      //reset bet to regular bet(after doubling)
                    }
                else {
                    times_lost += 1;
                    bet = bet*2;       //double bet each time you lose
                    }
                profit = savings - firstsavings;
                System.out.print("Geld: " + savings + "\t" + "Bilanz Spiel/Gesamt: " + (win==1 ? ("+" + profit_round) : (-bet)) + "/" + (profit>0 ? "+" : "") + profit);    //print one game's result
                System.out.println("\tEinsatz: " + todaybet + "\tSpiel: " + (i+1) + "\tTag: " + (ii+1) + (win==1 ? "\tGewonnen!" : "\tVerloren :("));                          //
                if (savings - bet < todayfirstsavings - maxloss) break;
                if (savings >= todayfirstsavings + maxprofit) break;
                if (savings - bet < 0) break outer;
            }
            //System.out.println("Geld: " + savings + "\t" + "Bilanz Gesamt: " + "" + (profit>0 ? "+" : "") + profit + "\tTag: " + (ii+1));     //print daily result
        }
        System.out.println("Ihr Endergebnis: " + savings + "\t" + "Bilanz: " + (profit>0 ? "+" : "") + profit + "\tSpiele gewonnen: " + times_won + "\tSpiele verloren: " + times_lost);      //print result of 1 rep
        if (rep < repetitions) System.out.println("Ihr Gewinn pro Spiel: " + ( (float)profit / ( (float)(times_won+times_lost) ) )    );   //print average profit per game of 1 whole rep
        System.out.println();
        reps_won = (profit >= 0) ? reps_won + 1 : reps_won - 1;
        }
    //System.out.println(reps_won);      //number of repetitions that ended up making profit or at least no loss
    }
}