public with sharing class SalesForecastController {
    
    public class ForecastRowWrapper {
        @AuraEnabled public Id recordId;
        @AuraEnabled public String region;
        @AuraEnabled public String territory;
        @AuraEnabled public String accountName;
        @AuraEnabled public Decimal oct;
        @AuraEnabled public Decimal nov;
        @AuraEnabled public Decimal dec;
        @AuraEnabled public Decimal jan;
        @AuraEnabled public Decimal feb;
        @AuraEnabled public Decimal mar;
        @AuraEnabled public Decimal apr;
        @AuraEnabled public Decimal may;
        @AuraEnabled public Decimal jun;
        @AuraEnabled public Decimal jul;
        @AuraEnabled public Decimal aug;
        @AuraEnabled public Decimal sep;
        @AuraEnabled public Decimal rowTotal;

        public ForecastRowWrapper(Sales_Forecast__c forecast) {
            recordId = forecast.Id;
            region = forecast.Region__c;
            territory = forecast.RFT_A_Territory__c;
            // Optional: Uncomment if you add these fields
            // territory = forecast.Territory__c;
            // accountName = forecast.Account__r != null ? forecast.Account__r.Name : '';

            oct = forecast.Oct__c != null ? forecast.Oct__c : 0;
            nov = forecast.Nov__c != null ? forecast.Nov__c : 0;
            dec = forecast.Dec__c != null ? forecast.Dec__c : 0;
            jan = forecast.Jan__c != null ? forecast.Jan__c : 0;
            feb = forecast.Feb__c != null ? forecast.Feb__c : 0;
            mar = forecast.Mar__c != null ? forecast.Mar__c : 0;
            apr = forecast.Apr__c != null ? forecast.Apr__c : 0;
            may = forecast.May__c != null ? forecast.May__c : 0;
            jun = forecast.Jun__c != null ? forecast.Jun__c : 0;
            jul = forecast.Jul__c != null ? forecast.Jul__c : 0;
            aug = forecast.Aug__c != null ? forecast.Aug__c : 0;
            sep = forecast.Sep__c != null ? forecast.Sep__c : 0;

            rowTotal = oct + nov + dec + jan + feb + mar + apr + may + jun + jul + aug + sep;
        }
    }

    public class ForecastSummaryWrapper {
        @AuraEnabled public List<ForecastRowWrapper> records = new List<ForecastRowWrapper>();
        @AuraEnabled public Decimal totalOct = 0;
        @AuraEnabled public Decimal totalNov = 0;
        @AuraEnabled public Decimal totalDec = 0;
        @AuraEnabled public Decimal totalJan = 0;
        @AuraEnabled public Decimal totalFeb = 0;
        @AuraEnabled public Decimal totalMar = 0;
        @AuraEnabled public Decimal totalApr = 0;
        @AuraEnabled public Decimal totalMay = 0;
        @AuraEnabled public Decimal totalJun = 0;
        @AuraEnabled public Decimal totalJul = 0;
        @AuraEnabled public Decimal totalAug = 0;
        @AuraEnabled public Decimal totalSep = 0;
        @AuraEnabled public Decimal grandTotal = 0;
    }

    @AuraEnabled(cacheable=true)
    public static ForecastSummaryWrapper getForecastData() {
        List<Sales_Forecast__c> forecasts = [
            SELECT Id, Region__c,RFT_A_Territory__c,
                   Oct__c, Nov__c, Dec__c, Jan__c, Feb__c,
                   Mar__c, Apr__c, May__c, Jun__c, Jul__c,
                   Aug__c, Sep__c
            FROM Sales_Forecast__c
        ];

        ForecastSummaryWrapper summary = new ForecastSummaryWrapper();

        for (Sales_Forecast__c f : forecasts) {
            ForecastRowWrapper row = new ForecastRowWrapper(f);
            summary.records.add(row);

            summary.totalJan += row.jan;
            summary.totalFeb += row.feb;
            summary.totalMar += row.mar;
            summary.totalApr += row.apr;
            summary.totalMay += row.may;
            summary.totalJun += row.jun;
            summary.totalJul += row.jul;
            summary.totalAug += row.aug;
            summary.totalSep += row.sep;
            summary.totalOct += row.oct;
            summary.totalNov += row.nov;
            summary.totalDec += row.dec;
            summary.grandTotal += row.rowTotal;
        }
        return summary;
    }

    @AuraEnabled
    public static void updateForecastData(List<Object> updatedRecords) {
        if (updatedRecords == null || updatedRecords.isEmpty()) return;

        List<Sales_Forecast__c> recordsToUpdate = new List<Sales_Forecast__c>();

        for (Object obj : updatedRecords) {
            String jsonString = JSON.serialize(obj);
            system.debug('jsonString '+jsonString);
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
			system.debug('data '+data);
            Id recordId = (Id) data.get('Id');
            system.debug('recordId '+recordId);
            if (recordId == null) continue;

            Sales_Forecast__c forecast = new Sales_Forecast__c(Id = recordId);
			system.debug('oct---- '+(Decimal) data.get('oct__c'));
            if (data.containsKey('oct__c')) forecast.Oct__c = (Decimal) data.get('oct__c');
            if (data.containsKey('nov__c')) forecast.Nov__c = (Decimal) data.get('nov__c');
            if (data.containsKey('dec__c')) forecast.Dec__c = (Decimal) data.get('dec__c');
            if (data.containsKey('jan__c')) forecast.Jan__c = (Decimal) data.get('jan__c');
            if (data.containsKey('feb__c')) forecast.Feb__c = (Decimal) data.get('feb__c');
            if (data.containsKey('mar__c')) forecast.Mar__c = (Decimal) data.get('mar__c');
            if (data.containsKey('apr__c')) forecast.Apr__c = (Decimal) data.get('apr__c');
            if (data.containsKey('may__c')) forecast.May__c = (Decimal) data.get('may__c');
            if (data.containsKey('jun__c')) forecast.Jun__c = (Decimal) data.get('jun__c');
            if (data.containsKey('jul__c')) forecast.Jul__c = (Decimal) data.get('jul__c');
            if (data.containsKey('aug__c')) forecast.Aug__c = (Decimal) data.get('aug__c');
            if (data.containsKey('sep__c')) forecast.Sep__c = (Decimal) data.get('sep__c');
			system.debug('forecast '+forecast.oct__c);
            recordsToUpdate.add(forecast);
        }

        if (!recordsToUpdate.isEmpty()) {
            update recordsToUpdate;
        }
    }
}