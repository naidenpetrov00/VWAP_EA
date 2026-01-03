double VWAP_Value = 0.0;
double VWAP_Upper[3];
double VWAP_Lower[3];

datetime VWAP_SessionStart = 0;

datetime VWAP_GetSessionStart(datetime nowUtc)
{
   MqlDateTime t;
   TimeToStruct(nowUtc, t);
   
   if(t.hour >= 00)
      t.day = t.day;
   else
      t.day -= 1;
      
   t.hour = 00;
   t.min  = 0;
   t.sec  = 0;

   return StructToTime(t);
}

bool VWAP_IsNewSession()
{
   datetime nowUtc = TimeGMT();
   datetime sessionStart = VWAP_GetSessionStart(nowUtc);
   
   if(sessionStart != VWAP_SessionStart)
     {
         VWAP_SessionStart = sessionStart;
         return true;
     }
   return false;
}

void VWAP_Calculate(ENUM_TIMEFRAMES TF)
{
   double sumTotalTradedValue = 0.0;
   long sumTotalTradedVolume = 0.0;
   double sumVolumeWeightedDeviation = 0.0;
   
   int bars = Bars(_Symbol, TF);
 
   for (int i = 0; i < bars; i++)
   {
      datetime barTime = iTime(_Symbol, TF, i);
      if (barTime < VWAP_SessionStart)
         break;
        
      double price = (iHigh(_Symbol,TF,i)
                    + iLow(_Symbol,TF,i)
                    + iClose(_Symbol,TF,i)) 
                    / 3;
      long volume = iVolume(_Symbol,TF,i);
      
      sumTotalTradedValue += price * volume;
      sumTotalTradedVolume += volume;
   }
   
   if (sumTotalTradedVolume == 0.0)
      return;
      
   VWAP_Value = sumTotalTradedValue / sumTotalTradedVolume;
   
   for (int i = 0; i < bars; i++)
   {
      datetime barTime = iTime(_Symbol, TF, i);
      if (barTime < VWAP_SessionStart)
         break;
        
      double price = (iHigh(_Symbol,TF,i)
                    + iLow(_Symbol,TF,i)
                    + iClose(_Symbol,TF,i)) 
                    / 3;
      long volume = iVolume(_Symbol,TF,i);
      
      sumVolumeWeightedDeviation += MathPow(price - VWAP_Value, 2) * volume;
   }
   
   double std = MathSqrt(sumVolumeWeightedDeviation / sumTotalTradedVolume);
   
   for(int i=0;i<3;i++)
     {
         double deviation = std * (i + 1);
         VWAP_Upper[i] = VWAP_Value + deviation;
         VWAP_Lower[i] = VWAP_Value - deviation;
     }
   for(int i = 0; i < ArraySize(VWAP_Upper); i++)
      {
         Print("Upper", VWAP_Upper[i]);
      }
   Print("VWAP" + VWAP_Value);
   for(int i = 0; i < ArraySize(VWAP_Lower); i++)
      {
         Print("Lower", VWAP_Lower[i]);
      }
}