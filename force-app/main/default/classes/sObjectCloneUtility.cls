public without sharing class sObjectCloneUtility {
    private Map<String, ChildRelationshipProps> relationshipMap;
    private SObjectType s_type;
    
    //The SObject that will be cloned. Accessible so modications can be made prior to saving
    public SObject clone;

    /**
      * @description Constructor to query object
      * @param toCloneId: Id to clone.  All creatable fields will be pulled
      * @param relationshipsToClone: Child Relationship names
      */
    public sObjectCloneUtility(Id toCloneId, Set<String> relationshipsToClone,Boolean includeAllChildRelationsOnParentsObject) {
        s_type = toCloneId.getSObjectType();
        if(relationshipsToClone==NULL)
            relationshipsToClone=new Set<String>();
        if(includeAllChildRelationsOnParentsObject)
            for(Schema.ChildRelationship cr: s_type.getDescribe().getChildRelationships())
            	if(cr.getRelationshipName()!=NULL && cr.getChildSObject().getDescribe().isCreateable() && cr.getChildSObject().getDescribe().isQueryable() &&
               	  !cr.getChildSObject().getDescribe().getName().endsWithIgnoreCase('Share') &&
                   ((cr.getRelationshipName().endsWith('__r') && cr.getChildSObject().getDescribe().isCustom()) || 
               		(!cr.getRelationshipName().endsWith('__r') && !cr.getChildSObject().getDescribe().isCustom()))
                    ){
                	 relationshipsToClone.add(cr.getRelationshipName());
                     if(relationshipsToClone.size()>19)
                         break; 
                    }
        mapStringsToRelations(relationshipsToClone);
        retrieveSObject(toCloneId);
	}

    /**
      * @description Constructor without object query.  Allows more control of cloning
      * @param toClone: SObject to clone.  Must include all relevant information
      * @param relationshipsToClone: Child Relationship names
    */
    public sObjectCloneUtility(SObject toClone, Set<String> relationshipsToClone,Boolean includeAllChildRelationsOnParentsObject) {
        s_type = toClone.getSObjectType();
        if(relationshipsToClone==NULL)
            relationshipsToClone=new Set<String>();
        if(includeAllChildRelationsOnParentsObject)
            for(Schema.ChildRelationship cr: s_type.getDescribe().getChildRelationships())
            	if(cr.getRelationshipName()!=NULL && cr.getChildSObject().getDescribe().isCreateable() && cr.getChildSObject().getDescribe().isQueryable() &&
               	  !cr.getChildSObject().getDescribe().getName().endsWithIgnoreCase('Share') &&
                   ((cr.getRelationshipName().endsWith('__r') && cr.getChildSObject().getDescribe().isCustom()) || 
               		(!cr.getRelationshipName().endsWith('__r') && !cr.getChildSObject().getDescribe().isCustom()))
                    ){
                	 relationshipsToClone.add(cr.getRelationshipName());
                     if(relationshipsToClone.size()>19)
                         break; 
                    }
        mapStringsToRelations(relationshipsToClone);
        this.clone = toClone;
	}

    /**
      * @description Saves the Cloned SObject
      * @return The Id of the cloned SObject
      */
    public Id save(){
        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        try {
            insert clone;
            for(String relationshipName : this.relationshipMap.keySet()){
                SObject[] clonedChildren = new SObject[]{};
                ChildRelationshipProps rel = this.relationshipMap.get(relationshipName);
                for(Sobject child : clone.getSObjects(relationshipName)){
                    SObject childClone = child.clone(false);
                    childClone.put(rel.field, clone.Id);
                    clonedChildren.add(childClone);
                }
                insert clonedChildren;
            }

        }catch(Exception e){
            Database.rollback(sp);
            throw e;
        }
        return clone.Id;
    }
    
    private void mapStringsToRelations(Set<String> relationshipStrings){
        this.relationshipMap = new Map<string, ChildRelationshipProps>();
        Map<String, ChildRelationship> childRelationMap = new Map<String, ChildRelationship>();
        for(ChildRelationship rel : s_type.getDescribe().getChildRelationships()){
            String relName = rel.getRelationshipName();
            if(relName != null){
                childRelationMap.put(rel.getRelationshipName().toUpperCase(), rel);
            }
        }
		for(String relStr : relationshipStrings){
            relStr = relStr.toUpperCase();
            if(childRelationMap.containsKey(relStr)){
                ChildRelationship rel = childRelationMap.get(relStr);
                relationshipMap.put(rel.getRelationshipName().toUpperCase(), new ChildRelationshipProps(rel));
            }else{
                throw new DeepCloneException(
                    'Child Relationship \'' + relStr + '\' does not exsist on ' + s_type.getDescribe().getName()
                );
            }
        }
    }

    private void retrieveSObject(Id toCloneId){
        // Get a map of field name and field token
        String[] selectFields = getCreatableFields(s_type);

        //subqueries
        for(String relationName : this.relationshipMap.keySet()){
            ChildRelationshipProps rel = this.relationshipMap.get(relationName);
            String[] relationFields = getCreatableFields(rel.sObjectType);
            if(relationFields.size() > 0){
                selectFields.add('(' + buildQuery(relationFields, relationName, null) + ')');
            }
            else
                this.relationshipMap.remove(relationName);
        }

        String qry = buildQuery(
            selectFields,
            s_type.getDescribe().getName(),
            'ID = \''+String.escapeSingleQuotes(toCloneId)+'\''
        );
        this.clone = ((SObject) Database.query(qry)).clone(false);
    }

    private string buildQuery(String[] fields, String fromObj, string whereClause){
        String qry = 'SELECT ' + String.join(fields, ',') + ' FROM ' + fromObj;
        if(!String.isEmpty(whereClause)){
            qry += ' WHERE ' + whereClause;
        }
        return qry;
    }

    private String[] getCreatableFields(SObjectType objType){
        DescribeSObjectResult describe = objType.getDescribe();

        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = describe.Fields.getMap();
        String[] selectFields = new String[]{};

        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isAccessible() && fd.isUpdateable() && fd.isCreateable() && !fd.isUnique() && fd.getType()!=Schema.DisplayType.base64 ){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
        return selectFields;
    }

    //seralizable subset of ChildRelationship properties that we need
    private class ChildRelationshipProps{
        public SObjectType sObjectType;
        public SObjectField field;
        public ChildRelationshipProps(ChildRelationship rel){
            this.sObjectType = rel.getChildSObject();
            this.field = rel.getField();
        }
    }
    public class DeepCloneException extends Exception {}
}