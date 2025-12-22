double VWAP_Value = 0.0;
double VWAP_Upper[3];
double VWAP_Lower[3];

datetime VWAP_SessionStart = 0;

datetime VWAP_GetSessionStart(datetime nowUtc)
{
   MqlDateTime t;
   TimeToStruct(nowUtc, t);
   
   if(t.hour >= 23)
      t.day = t.day;
   else
      t.day -= 1;
      
   t.hour = 23;
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
   double sumTotalTradedVolume = 0.0;
   double sumVolumeWeightedDeviation = 0.0;
   Print(sumTotalTradedValue);
}