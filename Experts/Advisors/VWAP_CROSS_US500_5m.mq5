//+------------------------------------------------------------------+
//|                                          VWAP_CROSS_US500_5m.mq5 |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Indicator/VWAP.mqh>

#define VWAP_LINE      "VWAP_MAIN"
#define VWAP_U1        "VWAP_U1"
#define VWAP_U2        "VWAP_U2"
#define VWAP_U3        "VWAP_U3"
#define VWAP_L1        "VWAP_L1"
#define VWAP_L2        "VWAP_L2"
#define VWAP_L3        "VWAP_L3"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
//---
int OnInit()
{
    VWAP_IsNewSession();       
    VWAP_Calculate(PERIOD_M5); 
    PlotVWAP();                
    
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
      
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    static datetime lastBar = 0;
    datetime currentBar = iTime(_Symbol, PERIOD_M5, 0);

   if (currentBar != lastBar)
   {
      lastBar = currentBar;

      if (VWAP_IsNewSession())
         ClearVWAPSegments();

      VWAP_Calculate(PERIOD_M5);
      PlotVWAP();
   }
}


//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---
  }
//+------------------------------------------------------------------+

void DrawSegment(string prefix, datetime t1, datetime t2, double price, color clr, int width)
{
    string name = prefix + "_" + IntegerToString((long)t1);

    if (ObjectFind(0, name) >= 0)
        return;

    ObjectCreate(0, name, OBJ_TREND, 0, t1, price, t2, price);
    ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
    ObjectSetInteger(0, name, OBJPROP_WIDTH, width);
    ObjectSetInteger(0, name, OBJPROP_RAY_RIGHT, false);
}

void PlotVWAP()
{
    datetime barStart = iTime(_Symbol, PERIOD_M5, 0);
    datetime barEnd   = barStart + PeriodSeconds(PERIOD_M5);

    DrawSegment("VWAP", barStart, barEnd, VWAP_Value, clrGold, 2);

    DrawSegment("VWAP_U1", barStart, barEnd, VWAP_Upper[0], clrDodgerBlue, 1);
    DrawSegment("VWAP_U2", barStart, barEnd, VWAP_Upper[1], clrDodgerBlue, 1);
    DrawSegment("VWAP_U3", barStart, barEnd, VWAP_Upper[2], clrDodgerBlue, 1);

    DrawSegment("VWAP_L1", barStart, barEnd, VWAP_Lower[0], clrTomato, 1);
    DrawSegment("VWAP_L2", barStart, barEnd, VWAP_Lower[1], clrTomato, 1);
    DrawSegment("VWAP_L3", barStart, barEnd, VWAP_Lower[2], clrTomato, 1);
}

void ClearVWAPSegments()
{
    ObjectsDeleteAll(0, "VWAP");
    ObjectsDeleteAll(0, "VWAP_U");
    ObjectsDeleteAll(0, "VWAP_L");
}
