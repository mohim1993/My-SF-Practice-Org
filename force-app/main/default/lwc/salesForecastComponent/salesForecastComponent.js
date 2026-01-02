import { LightningElement, track } from 'lwc';
import getForecastData from '@salesforce/apex/SalesForecastController.getForecastData';
import updateForecastData from '@salesforce/apex/SalesForecastController.updateForecastData';

export default class SalesForecastComponent extends LightningElement {
    @track error;
    @track groupedData = [];
    @track isEditMode = false;
    @track totalValuesArray = [];
    originalData = [];

    monthLabels = [
        { key: 'oct', label: 'Oct' },
        { key: 'nov', label: 'Nov' },
        { key: 'dec', label: 'Dec' },
        { key: 'jan', label: 'Jan' },
        { key: 'feb', label: 'Feb' },
        { key: 'mar', label: 'Mar' },
        { key: 'apr', label: 'Apr' },
        { key: 'may', label: 'May' },
        { key: 'jun', label: 'Jun' },
        { key: 'jul', label: 'Jul' },
        { key: 'aug', label: 'Aug' },
        { key: 'sep', label: 'Sep' }
    ];

    connectedCallback() {
        this.loadForecastData();
    }

    loadForecastData() {
        getForecastData()
            .then((result) => {
                this.groupDataByRegionAndTerritory(result.records);
                this.originalData = JSON.parse(JSON.stringify(this.groupedData));
                this.calculateTotalValues();
            })
            .catch((error) => {
                this.error = error;
            });
    }

    groupDataByRegionAndTerritory(records) {
        const regionMap = {};

        records.forEach((row) => {
            const region = row.region || 'Unknown Region';
            const territory = row.territory || 'Unknown Territory';

            if (!regionMap[region]) {
                regionMap[region] = {
                    region,
                    territories: {}
                };
            }

            if (!regionMap[region].territories[territory]) {
                regionMap[region].territories[territory] = {
                    territory,
                    rows: []
                };
            }

            const rowMonthValues = this.monthLabels.map((month, index) => {
                const value = row[month.key] || 0;
                return {
                    key: month.key,
                    index,
                    value
                };
            });

            regionMap[region].territories[territory].rows.push({
                ...row,
                monthValues: rowMonthValues
            });
        });

        const groupedList = [];
        Object.values(regionMap).forEach(regionGroup => {
            const regionRows = [];

            Object.values(regionGroup.territories).forEach(territoryGroup => {
                territoryGroup.rows.forEach((row, index) => {
                    row.isFirstTerritoryRow = index === 0;
                    row.territoryRowCount = territoryGroup.rows.length;
                });

                regionRows.push(...territoryGroup.rows);
            });

            regionRows.forEach((row, index) => {
                row.isFirstRegionRow = index === 0 || row.region !== regionRows[index - 1].region;
            });

            groupedList.push({
                region: regionGroup.region,
                rows: regionRows
            });
        });

        this.groupedData = groupedList;
    }

    calculateTotalValues() {
        const totals = {};
        this.monthLabels.forEach(month => {
            totals[month.key] = 0;
        });

        this.groupedData.forEach(group => {
            group.rows.forEach(row => {
                row.monthValues.forEach(monthValue => {
                    totals[monthValue.key] += parseFloat(monthValue.value) || 0;
                });
            });
        });

        this.totalValuesArray = this.monthLabels.map(month => {
            return {
                key: month.key,
                value: totals[month.key]
            };
        });
    }

    handleEditClick() {
        this.isEditMode = true;
    }

    handleCancelClick() {
        this.groupedData = JSON.parse(JSON.stringify(this.originalData));
        this.isEditMode = false;
        this.calculateTotalValues();
    }

    handleSaveClick() {
        const updatedRecords = [];

        this.groupedData.forEach(group => {
            group.rows.forEach(row => {
                const record = { Id: row.recordId };
                row.monthValues.forEach(month => {
                    const fieldApi = month.key + '__c';
                    record[fieldApi] = month.value;
                });
                updatedRecords.push(record);
            });
        });

        updateForecastData({ updatedRecords })
            .then(() => {
                this.originalData = JSON.parse(JSON.stringify(this.groupedData));
                this.isEditMode = false;
                this.calculateTotalValues();
            })
            .catch(error => {
                this.error = error.body?.message || 'Unknown error';
                console.error('Error updating forecast:', error);
            });
    }

    handleInputChange(event) {
        const field = event.target.dataset.field;
        const recordId = event.target.dataset.id;
        const newValue = parseFloat(event.target.value) || 0;

        const updatedGroups = JSON.parse(JSON.stringify(this.groupedData));
        updatedGroups.forEach(group => {
            group.rows.forEach(row => {
                if (row.recordId === recordId) {
                    const monthObj = row.monthValues.find(m => m.key === field);
                    if (monthObj) {
                        monthObj.value = newValue;
                    }
                }
            });
        });

        this.groupedData = updatedGroups;
        this.calculateTotalValues();
    }
}