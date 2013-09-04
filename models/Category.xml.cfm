<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="Name" desc="Name">
			<rule type="required" contexts="create,update" />
			<rule type="maxLength" contexts="create,update">
				<param name="maxLength" value="50" />
			</rule>
			<rule type="custom" contexts="create,update" failureMessage="The name has to be unique.">
        		<param name="methodname" value="isNameUnique" />
		    </rule>
		</property>
	</objectProperties>
</validateThis>