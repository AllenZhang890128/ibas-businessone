package org.colorcoding.ibas.bobas.businessone.serialization;

import java.io.InputStream;
import java.io.OutputStream;

import org.colorcoding.ibas.bobas.serialization.SerializationException;
import org.colorcoding.ibas.bobas.serialization.ValidateException;
import org.xml.sax.InputSource;

import com.github.fge.jsonschema.main.JsonSchema;
import com.sap.smb.sbo.api.ICompany;

public class B1SerializerJson extends B1Serializer<JsonSchema> {

	public B1SerializerJson(ICompany b1Company) {
		super(b1Company);
	}

	@Override
	public void getSchema(Class<?> arg0, OutputStream arg1) throws SerializationException {
		// TODO Auto-generated method stub

	}

	@Override
	public void serialize(Object object, OutputStream outputStream, boolean formated, Class<?>... types) {
		// TODO Auto-generated method stub

	}

	@Override
	public Object deserialize(InputSource inputSource, Class<?>... types) throws SerializationException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void validate(JsonSchema schema, InputStream data) throws ValidateException {
		// TODO Auto-generated method stub

	}

	@Override
	public JsonSchema getSchema(Class<?> type) throws SerializationException {
		// TODO Auto-generated method stub
		return null;
	}

}