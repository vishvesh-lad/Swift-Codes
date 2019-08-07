package com.developer.homeinspecttech.utility;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.res.ColorStateList;
import android.content.res.Resources;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Point;
import android.location.Address;
import android.location.Geocoder;
import android.net.Uri;
import android.provider.MediaStore;
import android.support.annotation.NonNull;
import android.support.media.ExifInterface;
import android.support.v4.content.CursorLoader;
import android.support.v4.view.ViewCompat;
import android.view.Display;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.Toast;

import com.developer.homeinspecttech.BuildConfig;
import com.developer.homeinspecttech.R;
import com.developer.homeinspecttech.constant.AppConstant;
import com.developer.homeinspecttech.constant.EnumConstant;
import com.developer.homeinspecttech.constant.EnumHomeEnergyConstant;
import com.developer.homeinspecttech.dao.db.Contact;
import com.developer.homeinspecttech.dao.db.Employee;
import com.developer.homeinspecttech.dao.db.Inspection_Property;
import com.developer.homeinspecttech.dao.manager.DatabaseManager;
import com.developer.homeinspecttech.model.eventbus.HomeEnergyAssessmentsEvent;
import com.developer.homeinspecttech.model.eventbus.HomeEnergyHelpEvent;
import com.developer.homeinspecttech.model.inspectionmodel.ContactModel;
import com.developer.homeinspecttech.model.inspectionmodel.EmployeeModel;
import com.developer.homeinspecttech.model.inspectionmodel.InspectionAdapterModel;
import com.developer.homeinspecttech.model.inspectionmodel.PropertyModel;
import com.developer.homeinspecttech.modules.inspector.home_energy.AboutHomeActivity;
import com.developer.homeinspecttech.modules.inspector.home_energy.HeatingAndCoolingSystemActivity;
import com.developer.homeinspecttech.modules.inspector.home_energy.HomeEnergyHelpDialogActivity;
import com.developer.homeinspecttech.modules.inspector.home_energy.HomePerformanceActivity;
import com.developer.homeinspecttech.modules.inspector.home_energy.PhotovoltaicSystemActivity;
import com.developer.homeinspecttech.modules.inspector.home_energy.RoofAtticFoundationActivity;
import com.developer.homeinspecttech.modules.inspector.home_energy.WallsActivity;
import com.developer.homeinspecttech.modules.inspector.home_energy.WindowAndSkylightActivity;
import com.developer.homeinspecttech.modules.inspector.settings.LicenseExpirationActivity;
import com.developer.homeinspecttech.networkcall.HttpRequestHandler;
import com.developer.homeinspecttech.sharedpreference.SharedPreference;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.libraries.places.compat.Place;
import com.yalantis.ucrop.UCrop;

import org.greenrobot.eventbus.EventBus;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.math.RoundingMode;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.channels.FileChannel;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import java8.util.Optional;
import java8.util.stream.StreamSupport;
import okhttp3.MediaType;
import okhttp3.RequestBody;

public class DataTypeUtil {

    private static DataTypeUtil mInstance = null;
    public String TAG = getClass().getName();
    private static Toast toast;

    public static DataTypeUtil getInstance() {
        if (mInstance == null) {
            mInstance = new DataTypeUtil();
        }
        return mInstance;
    }

    public String getAppVersion() {
        String appVersion = "";
        try {
            // with package manager
            //appVersion = context.getPackageManager().getPackageInfo(context.getPackageName(), 0).versionName;
            appVersion = BuildConfig.VERSION_NAME;// with build config
        } catch (Exception e) {
            e.printStackTrace();
            return appVersion;
        }
        return appVersion;
    }

    public void showToast(Context context, String message) {// change it like awk
        if (message == null || message.isEmpty() || context == null)
            return;

        if (toast != null) toast.cancel();
        toast = Toast.makeText(context, message, Toast.LENGTH_SHORT);
        toast.setGravity(Gravity.CENTER, 0, 0);
        toast.show();
    }

    public void showToastLengthLong(Context context, String message) {
        if (message == null || message.isEmpty() || context == null)
            return;

        if (toast != null) toast.cancel();
        toast = Toast.makeText(context, message, Toast.LENGTH_LONG);
        toast.setGravity(Gravity.CENTER, 0, 0);
        toast.show();
    }

    // get response status 0 true or 1 false
    public boolean isResponseSuccess(String value) {
        return value.equals("0");
    }

    public boolean intToBoolean(int value) {
        // Convert 0 to false else true.
        return value != 0;
    }

    public int booleanToInt(boolean value) {
        // Convert true to 1 and false to 0.
        return value ? 1 : 0;
    }

    public String intBooleanToString(int value) {
        // Convert 0 to false else true.
        return value != 0 ? "true" : "false";
    }

    public boolean stringToBoolean(String value) {
        // Convert "true" to true else false.
        return value.equals("true");
    }

    public int convertIsUploadedToUploadRequired(boolean value) {
        // Convert true to 0 and false to 1.
        return value ? 0 : 1;
    }

    // convert json object in to request body
    public RequestBody prepareRequestBody(JSONObject postData) {
        return RequestBody.create(MediaType.parse(AppConstant.HI_MediaType), (postData).toString());
    }

    // prepare list of inspection detail menus
    public ArrayList<String> getInspectionDetailMenuList(Context context) {
        ArrayList<String> menuList = new ArrayList<>();
        menuList.add(context.getString(R.string.title_inspector_information));
        menuList.add(context.getString(R.string.title_contact_information));
        menuList.add(context.getString(R.string.title_invoice));
        menuList.add(context.getString(R.string.title_services));
        menuList.add(context.getString(R.string.title_agreements));
        menuList.add(context.getString(R.string.title_inspection_note));
        menuList.add(context.getString(R.string.title_reports));
        return menuList;
    }

    // prepare list of appointment detail menus
    public ArrayList<String> getAppointmentDetailMenuList(Context context) {
        ArrayList<String> menuList = new ArrayList<>();
        menuList.add(context.getString(R.string.title_inspector_information));
        menuList.add(context.getString(R.string.title_contact_information));
        menuList.add(context.getString(R.string.title_invoice));
        menuList.add(context.getString(R.string.title_services));
        menuList.add(context.getString(R.string.title_agreements));
        menuList.add(context.getString(R.string.title_reports));
        return menuList;
    }

    // prepare list of settings menus
    public ArrayList<String> getSettingsMenuList(Context context) {
        ArrayList<String> menuList = new ArrayList<>();
        menuList.add(context.getString(R.string.title_change_password));
        menuList.add(context.getString(R.string.title_activate_license_code));
        menuList.add(context.getString(R.string.title_manage_log_files));
        menuList.add(context.getString(R.string.title_image_configuration));
        menuList.add(context.getString(R.string.title_clear_Inspection_data));
        menuList.add(context.getString(R.string.title_upload_app_db));
        menuList.add(context.getString(R.string.title_upload_pending_media));
        return menuList;
    }

    public ArrayList<String> getPriority(Context context) {
        ArrayList<String> priorityList = new ArrayList<>();
        priorityList.add(context.getString(R.string.text_high));
        priorityList.add(context.getString(R.string.text_medium));
        priorityList.add(context.getString(R.string.text_low));
        return priorityList;
    }

    // prepare list of review inspection report
    public ArrayList<String> getReview(Context context) {
        ArrayList<String> reviewList = new ArrayList<>();
        reviewList.add(context.getString(R.string.title_unanswered));
        reviewList.add(context.getString(R.string.title_bookmarked_comment));
        reviewList.add(context.getString(R.string.title_final_review));
        return reviewList;
    }

    // prepare list of settings image configuration menus
    public ArrayList<String> getImageConfigurationMenuList(Context context) {
        ArrayList<String> menuList = new ArrayList<>();
        menuList.add(context.getString(R.string.title_select_shape_color));
        menuList.add(context.getString(R.string.title_select_font_type));
        return menuList;
    }

    // prepare list of sync data menus
    public ArrayList<String> getSyncDataMenuList(Context context) {
        ArrayList<String> menuList = new ArrayList<>();
        menuList.add(context.getString(R.string.title_sync_templates));
        menuList.add(context.getString(R.string.title_sync_appliances_and_brand));
        return menuList;
    }

    // prepare list of inspection history filter
    public ArrayList<String> getInspectionHistoryFilterList(Context context) {
        ArrayList<String> filterList = new ArrayList<>();
        filterList.add(context.getString(R.string.text_yesterday));
        filterList.add(context.getString(R.string.text_this_week));
        filterList.add(context.getString(R.string.text_last_week));
        //filterList.add(context.getString(R.string.text_last_month));
        filterList.add(context.getString(R.string.text_custom));
        return filterList;
    }

    // prepare list of expenses filter
    public ArrayList<String> getExpensesFilterList(Context context) {
        ArrayList<String> filterList = new ArrayList<>();
        filterList.add(context.getString(R.string.text_all));
        filterList.add(context.getString(R.string.text_today));
        filterList.add(context.getString(R.string.text_yesterday));
        filterList.add(context.getString(R.string.text_this_week));
        filterList.add(context.getString(R.string.text_last_week));
        filterList.add(context.getString(R.string.text_last_month));
        filterList.add(context.getString(R.string.text_custom));
        return filterList;
    }

    // get name from contact object
    public String getName(Contact contact) {
        if (contact != null) {
            return concatName(contact.getFirst_name(), contact.getLast_name());
        }
        return "";
    }

    // get number from Contact
    public String getMobileNumber(Contact contact) {
        if (contact != null) {
            if (contact.getMobile_number() != null && !contact.getMobile_number().isEmpty()) {
                return contact.getMobile_number();
            } else if (contact.getPhone_number() != null && !contact.getPhone_number().isEmpty()) {
                return contact.getPhone_number();
            }
        }
        return "";
    }

    // get number from ContactModel
    public String getMobileNumber(ContactModel contactModel) {
        if (contactModel != null) {
            if (contactModel.mobile_number != null && !contactModel.mobile_number.isEmpty()) {
                return contactModel.mobile_number;
            } else if (contactModel.phone_number != null && !contactModel.phone_number.isEmpty()) {
                return contactModel.phone_number;
            }
        }
        return "";
    }

    // get number from Employee
    public String getMobileNumber(Employee employee) {
        if (employee != null) {
            if (employee.getMobile() != null && !employee.getMobile().isEmpty()) {
                return employee.getMobile();
            } else if (employee.getOffice_number() != null && !employee.getOffice_number().isEmpty()) {
                return employee.getOffice_number();
            }
        }
        return "";
    }

    // get number from Employee
    public String getMobileNumber(EmployeeModel employeeModel) {
        if (employeeModel != null) {
            if (employeeModel.mobile != null && !employeeModel.mobile.isEmpty()) {
                return employeeModel.mobile;
            } else if (employeeModel.office_number != null && !employeeModel.office_number.isEmpty()) {
                return employeeModel.office_number;
            }
        }
        return "";
    }


    // get address from property object (database model)
    public String getAddress(Context context, Inspection_Property property) {
        if (property != null) {
            String address1, address2, city, state = "", zip;
            address1 = property.getAddress_line1();
            address2 = property.getAddress_line2();
            city = property.getCity();
            if (property.getState_id() != 0L)
                state = DatabaseManager.getInstance(context).getStateByStateID(property.getState_id()).getState_name();
            zip = property.getZip_code();

            return address1 + (!address1.isEmpty() ? ", " : "") +
                    address2 + (!address2.isEmpty() ? ", " : "") +
                    city + (!city.isEmpty() ? ", " : "") +
                    state + (!state.isEmpty() ? ", " : "") +
                    zip;
        }
        return "";
    }

    // get address from property object API model
    public String getAddressForAppointment(Context context, PropertyModel property) {
        if (property != null) {
            String address1, address2, city, state = "", zip;
            address1 = property.address_line1;
            address2 = property.address_line2;
            city = property.city;
            if (property.state_id != 0L)
                state = DatabaseManager.getInstance(context).getStateByStateID(property.state_id).getState_name();
            zip = property.zip_code;

            return address1 + (!address1.isEmpty() ? ", " : "") +
                    address2 + (!address2.isEmpty() ? ", " : "") +
                    city + (!city.isEmpty() ? ", " : "") +
                    state + (!state.isEmpty() ? ", " : "") +
                    zip;
        }
        return "";
    }

    // get address from contact object
    public String getContactAddress(Context context, Contact contact) {
        if (contact != null) {
            String address1, state = "", zip;
            address1 = contact.getAddress();
            if (contact.getState_id() != 0L)
                state = DatabaseManager.getInstance(context).getStateByStateID(contact.getState_id()).getState_name();
            zip = contact.getZip_code();

            return (address1 != null && !address1.isEmpty() ? address1 + ", " : "") +
                    (state != null && !state.isEmpty() ? state + ", " : "") +
                    (zip != null && !zip.isEmpty() ? zip : "");
        }
        return "";
    }

    // get address from ContactModel object API model
    public String getContactAddressForAppointment(Context context, ContactModel contact) {
        if (contact != null) {
            String address1, state = "", zip;
            address1 = contact.address;
            if (contact.state_id != 0L)
                state = DatabaseManager.getInstance(context).getStateByStateID(contact.state_id).getState_name();
            zip = contact.zip_code;

            return (address1 != null && !address1.isEmpty() ? address1 + ", " : "") +
                    (state != null && !state.isEmpty() ? state + ", " : "") +
                    (zip != null && !zip.isEmpty() ? zip : "");
        }
        return "";
    }

    // set edit text background tint color
    public void setEditTextBackgroundTint(ArrayList<EditText> editTextList, ColorStateList colorStateList) {
        for (int i = 0; i < editTextList.size(); i++) {
            ViewCompat.setBackgroundTintList(editTextList.get(i), colorStateList);
        }
    }

    // manage edit text Focusable state
    public void manageFocusableState(ArrayList<EditText> editTextList, boolean isFocus) {
        for (int i = 0; i < editTextList.size(); i++) {
            editTextList.get(i).setEnabled(isFocus);
        }
    }

    // handle simple response
    public void handelUpdateResponses(Context context, String response, boolean isFinish) {
        if (response != null) {
            try {
                JSONObject jsonObject = new JSONObject(response);
                if (isResponseSuccess(String.valueOf(jsonObject.get(AppConstant.HI_res)))) {
                    showToast(context, String.valueOf(jsonObject.get(AppConstant.HI_msg)));
                    if (isFinish) {
                        ((Activity) context).finish();
                    }
                } else {
                    showToast(context, String.valueOf(jsonObject.get(AppConstant.HI_msg)));
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    }

    // hide soft keyboard
    public void hideKeyboard(Activity activity) {
        try {
            InputMethodManager inputManager = (InputMethodManager) activity.getSystemService(Context.INPUT_METHOD_SERVICE);
            assert inputManager != null;
            inputManager.hideSoftInputFromWindow(activity.getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void callIntent(Context context, String number) {
        try {
            String uri = "tel:" + number.trim();
            Intent intent = new Intent(Intent.ACTION_DIAL);
            intent.setData(Uri.parse(uri));
            context.startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void msgIntent(Context context, String msg, String number) {
        try {
            /*Intent smsIntent = new Intent(Intent.ACTION_VIEW);
            smsIntent.setType("vnd.android-dir/mms-sms");
            smsIntent.putExtra("address", number);
            smsIntent.putExtra("sms_body", msg);
            context.startActivity(smsIntent);*/

            Uri sms_uri = Uri.parse("smsto:" + number);
            Intent sms_intent = new Intent(Intent.ACTION_SENDTO, sms_uri);
            sms_intent.putExtra("sms_body", msg);
            context.startActivity(sms_intent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void emailIntent(Context context, String name, String emailID) {
        try {
            String body = name != null && !name.isEmpty() ? "Hey " + name : "";
            Intent testIntent = new Intent(Intent.ACTION_VIEW);
            Uri data = Uri.parse("mailto:?subject=" + "Home inspector tech" + "&body=" + body + "&to=" + emailID);
            testIntent.setData(data);
            context.startActivity(testIntent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // redirect on default google map application
    public void googleMapIntent(Context context, String label, Double latitude, Double longitude) {
        try {
            //String label = "I'm Here!";
            String uriBegin = "geo:" + latitude + "," + longitude;
            String query = latitude + "," + longitude + "(" + label + ")";
            String encodedQuery = Uri.encode(query);
            String uriString = uriBegin + "?q=" + encodedQuery + "&z=16";
            Uri uri = Uri.parse(uriString);
            Intent mapIntent = new Intent(Intent.ACTION_VIEW, uri);
            context.startActivity(mapIntent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void googleMapRedirection(Context context, LatLng currentLatLng, LatLng destinationLatLng) {
        try {
            String uriString = "http://maps.google.com/maps?f=d&hl=en&saddr=" + currentLatLng.latitude + "," + currentLatLng.longitude +
                    "&daddr=" + destinationLatLng.latitude + "," + destinationLatLng.longitude;
            Uri uri = Uri.parse(uriString);
            Intent mapIntent = new Intent(Intent.ACTION_VIEW, uri);
            context.startActivity(mapIntent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean checkForNewRecord(List<?> mData) {
        return !(mData != null && !mData.isEmpty());
    }

    public String getFormattedPrice(Context context, Double price) {
        return context.getString(R.string.text_dollar) + new DecimalFormat().format(getFormattedValue(price));//%.2f rounded floating value
    }

    public String getFormattedPriceWithCurrency(Context context, Double price) {
        return NumberFormat.getCurrencyInstance(Locale.US).format(getFormattedValue(price));
        //new DecimalFormat().format(getFormattedValue(price));//%.2f rounded floating value
    }

    public double getFormattedValue(Double price) {
        Double f1 = Double.parseDouble(String.valueOf(price == null ? 0 : price));
        DecimalFormat df = new DecimalFormat(".00");
        df.setRoundingMode(RoundingMode.DOWN); // Note this extra step
        return Double.parseDouble(df.format(f1));// NumberFormat.getCurrencyInstance().format();
    }

    public void setIntentForResult(Context context) {
        Intent intent = new Intent();
        ((Activity) context).setResult(Activity.RESULT_OK, intent);
        ((Activity) context).finish();
    }

    // get service status is running or not
    public boolean isServiceRunning(Context context, Class<?> serviceClass) {
        ActivityManager manager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        if (manager != null) {
            for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
                if (serviceClass.getName().equals(service.service.getClassName())) {
                    return true;
                }
            }
        }
        return false;
    }

    public String convertKmsToMiles(double kms) {
        double mile = 0.621371 * kms;
        if (mile == 0d) {
            return String.valueOf(0);
        } else {
            return String.format(Locale.getDefault(), "%.2f", mile);
        }
    }

    public String convertDoubleToString(double value) {
        if (value == 0d) {
            return String.valueOf(0);
        } else {
            return new DecimalFormat().format(getFormattedValue(value));
        }
    }

    public String modifyUrl(Context context, String result, String folderName) {
        URI uri = null;
        try {
            if (result != null && !result.isEmpty()) {
                uri = new URI(result);
                String path = uri.getPath();
                String filename = path.substring(path.lastIndexOf('/') + 1).replace(path.substring(path.lastIndexOf('.') + 1), "jpg");

                return context.getString(R.string.thumbnail_bucket_url,
                        context.getString(R.string.aws_base_url),
                        folderName,
                        filename);
            }
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
        return null;
    }

    /*public String modifyUrl(Context context, String result, String folderName) {
        URI uri = null;
        try {
            if (result != null && !result.isEmpty()) {
                uri = new URI(result);
                String path = uri.getPath();
                String filename = path.substring(path.lastIndexOf('/') + 1).replace(path.substring(path.lastIndexOf('.') + 1), "jpg");

                return context.getString(R.string.aws_base_url) +
                        "/" +
                        "home-inspection-thumbnail" +
                        "/" +
                        folderName +
                        "/" +
                        "thumb_" +
                        filename;
            }
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
        return null;
    }*/

    public boolean checkForReportStatus(int reportStatus) {
        return reportStatus == 1;
    }

    public String getFilePath(Context context, String url) {
        Uri uri = Uri.parse(url);
        String fileName = uri.getLastPathSegment();
        File filesDir = context.getCacheDir();

        return String.valueOf(Uri.parse(filesDir
                + "/"
                + fileName));//downloads/
    }

    public UCrop advancedConfig(Context context, @NonNull UCrop uCrop) {
        UCrop.Options options = new UCrop.Options();
        options.setHideBottomControls(true);
        options.setStatusBarColor(context.getResources().getColor(R.color.colorPrimaryDark));
        options.setToolbarColor(context.getResources().getColor(R.color.color_toolbar));
        return uCrop.withOptions(options);
    }

    public boolean isDataSynced(String key) {
        try {
            String syncDate = SharedPreference.getInstance().getStringFromPref(key, null);
            String today = DateTimeUtil.getInstance().getCurrentDate();
            if (syncDate == null || syncDate.isEmpty()) {
                return false;
            } else {
                Date lastSyncDate = new SimpleDateFormat(AppConstant.HI_DateFormat, Locale.getDefault()).parse(syncDate);
                Date currentDate = new SimpleDateFormat(AppConstant.HI_DateFormat, Locale.getDefault()).parse(today);
                return !currentDate.after(lastSyncDate);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void deleteFile(File file) {
        try {
            if (file != null && file.exists()) {
                file.delete();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getFilePathFromBitmap(Context context, Bitmap bitmap, String filename, String destPath) {
        try {
            String path = null;
            if (destPath != null) {
                File storageDir = new File(destPath);
                if (!storageDir.exists()) {
                    if (!storageDir.mkdirs()) {
                        path = context.getCacheDir() + "/" + filename;
                    }
                }
                if (path == null)
                    path = destPath + "/" + filename;
            } else {
                path = context.getCacheDir() + "/" + filename;
            }
            FileOutputStream outputStream = new FileOutputStream(path);
            bitmap.compress(Bitmap.CompressFormat.JPEG, 50, outputStream);
            outputStream.close();
            return path;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Uri getImageUri(Context inContext, Bitmap inImage) {
        ByteArrayOutputStream bytes = new ByteArrayOutputStream();
        inImage.compress(Bitmap.CompressFormat.JPEG, 100, bytes);
        String path = MediaStore.Images.Media.insertImage(inContext.getContentResolver(), inImage, "Title", null);
        return Uri.parse(path);
    }

    public String getRealPathFromURI(Context context, Uri contentUri) {
        String[] strArray = {MediaStore.Images.Media.DATA};

        //This method was deprecated in API level 11
        //Cursor cursor = managedQuery(contentUri, strArray, null, null, null);

        CursorLoader cursorLoader = new CursorLoader(context, contentUri, strArray, null, null, null);
        Cursor cursor = cursorLoader.loadInBackground();

        int column_index = 0;
        if (cursor != null) {
            column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
            cursor.moveToFirst();
        }
        return cursor != null ? cursor.getString(column_index) : null;
    }

    public String getRealImagePathFromURI(ContentResolver contentResolver,
                                          Uri contentURI) {
        Cursor cursor = contentResolver.query(contentURI, null, null, null,
                null);
        if (cursor == null)
            return contentURI.getPath();
        else {
            cursor.moveToFirst();
            int idx = cursor
                    .getColumnIndex(MediaStore.Images.ImageColumns.DATA);
            try {
                return cursor.getString(idx);
            } catch (Exception exception) {
                return null;
            }
        }
    }

    public Bitmap readPictureDegree(Bitmap bitmap, String path) {
        ExifInterface exifObject = null;
        try {
            exifObject = new ExifInterface(path);
        } catch (IOException e) {
            e.printStackTrace();
        }
        int orientation = 0;
        if (exifObject != null) {
            orientation = exifObject.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_UNDEFINED);
        }
        return rotateBitmap(bitmap, orientation);
    }

    private Bitmap rotateBitmap(Bitmap bitmap, int orientation) {
        Matrix matrix = new Matrix();
        switch (orientation) {
            case ExifInterface.ORIENTATION_NORMAL:
                return bitmap;
            case ExifInterface.ORIENTATION_FLIP_HORIZONTAL:
                matrix.setScale(-1, 1);
                break;
            case ExifInterface.ORIENTATION_ROTATE_180:
                matrix.setRotate(180);
                break;
            case ExifInterface.ORIENTATION_FLIP_VERTICAL:
                matrix.setRotate(180);
                matrix.postScale(-1, 1);
                break;
            case ExifInterface.ORIENTATION_TRANSPOSE:
                matrix.setRotate(90);
                matrix.postScale(-1, 1);
                break;
            case ExifInterface.ORIENTATION_ROTATE_90:
                matrix.setRotate(90);
                break;
            case ExifInterface.ORIENTATION_TRANSVERSE:
                matrix.setRotate(-90);
                matrix.postScale(-1, 1);
                break;
            case ExifInterface.ORIENTATION_ROTATE_270:
                matrix.setRotate(-90);
                break;
            default:
                return bitmap;
        }
        try {
            Bitmap bmRotated = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
            bitmap.recycle();
            return bmRotated;
        } catch (OutOfMemoryError e) {
            e.printStackTrace();
            return null;
        }
    }

    // is file exists then return local path otherwise return original Path
    public String getFileOfflineExists(String filePath) {
        try {
            File file = new File(AppConstant.HI_MEDIA_STORAGE_PATH +
                    AppConstant.HI_IMAGE_DIRECTORY +
                    File.separator +
                    Uri.parse(filePath).getLastPathSegment()); //Uri.parse(filePath).getLastPathSegment().replace("thumb_", "")
            if (file.exists()) {
                return file.getAbsolutePath();
            } else {
                return filePath;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return filePath;
        }
    }

    // is file exists then return local path otherwise return null
    public String getLocalFileExists(String filePath) {
        try {
            File file = new File(AppConstant.HI_MEDIA_STORAGE_PATH +
                    AppConstant.HI_IMAGE_DIRECTORY +
                    File.separator +
                    Uri.parse(filePath).getLastPathSegment());
            if (file.exists()) {
                return file.getAbsolutePath();
            } else {
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void renameFile(String newPath, String oldPath) {
        File from = new File(oldPath);
        File to = new File(newPath);
        from.renameTo(to);
    }

    public void manageViewAlpha(View view, boolean isClickable) {
        view.setClickable(isClickable);
        view.setAlpha(isClickable ? 1f : 0.5f);
    }

    public void copyFile(File sourceFile, File destFile) throws IOException {
        if (!destFile.getParentFile().exists())
            destFile.getParentFile().mkdirs();

        if (!destFile.exists()) {
            destFile.createNewFile();
        }

        FileChannel source = null;
        FileChannel destination = null;

        try {
            source = new FileInputStream(sourceFile).getChannel();
            destination = new FileOutputStream(destFile).getChannel();
            destination.transferFrom(source, 0, source.size());
        } finally {
            if (source != null) {
                source.close();
            }
            if (destination != null) {
                destination.close();
            }
        }
    }

    public void setAppLogFile(Context context, String fileName, String data) {
        String logData, deviceInfo = "";

        try {
            File file = new File(Globals.getContext().getFilesDir(), "AppLog");
            if (!file.exists()) {
                file.mkdir();
            }

            File myFile = new File(file, fileName);
            if (!myFile.exists()) {
                myFile.createNewFile();

                JSONObject device_info = HttpRequestHandler.getInstance().getDeviceInfoJson();

                deviceInfo = "\nDeviceInfo => " + device_info.toString() + "\n" + "==================================";

            }
            logData = deviceInfo + "\nDate => " + DateTimeUtil.getInstance()
                    .convertTimestampToDate(AppConstant.HI_DateTimeFormat, System.currentTimeMillis() / 1000)
                    + "\n" + data + "\n" + "==================================";

            FileOutputStream fOut = new FileOutputStream(myFile, true);
            OutputStreamWriter myOutWriter = new OutputStreamWriter(fOut);
            myOutWriter.append(logData);
            myOutWriter.close();
            fOut.close();

            /*FileWriter writer = new FileWriter(gpxfile);
            writer.append(logData);
            writer.flush();
            writer.close();*/

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public File getLogFile() {
        /*File file = new File(Globals.getContext().getFilesDir(), "AppLog");
        if (!file.exists()) {
            file.mkdir();
        }
        if (file.exists())
            return new File(file, AppConstant.HI_AppLogFileName);
        else
            return null;*/
        try {
            File dir = new File(Globals.getContext().getFilesDir(), "AppLog");
            if (dir.exists()) {
                for (File f : dir.listFiles()) {
                    if (f.getName().equals(AppConstant.HI_AppLogFileName))
                        return f;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int dpToPx(int dp) {
        return (int) (dp * Resources.getSystem().getDisplayMetrics().density);
    }

    public int pxToDp(int px) {
        return (int) (px / Resources.getSystem().getDisplayMetrics().density);
    }

    // is file exists then return local path otherwise return original Path
    public void deleteMediaFileFromExternalStorage(int mediaType, String filePath) {
        try {
            String folderName = mediaType == 2 ? AppConstant.HI_VIDEO_DIRECTORY : AppConstant.HI_IMAGE_DIRECTORY;
            File file = new File(AppConstant.HI_MEDIA_STORAGE_PATH +
                    folderName +
                    File.separator +
                    Uri.parse(filePath).getLastPathSegment());

            if (file.exists()) {
                file.delete();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Address getLocationFromAddress(Context context, Place place) {

        String strAddress = String.valueOf(place.getAddress());
        LatLng latLng = place.getLatLng();
        Geocoder coder = new Geocoder(context);
        List<Address> address;

        try {
            address = coder.getFromLocationName(strAddress,
                    5,
                    latLng.latitude,
                    latLng.longitude,
                    latLng.latitude,
                    latLng.longitude);
            if (address == null) {
                return null;
            }
            return address.get(0);
        } catch (IOException ex) {

            ex.printStackTrace();
        }

        return null;
    }

    public Address getLocationFromAddress(Context context, String strAddress) {

        Geocoder coder = new Geocoder(context);
        List<Address> address;

        try {
            address = coder.getFromLocationName(strAddress, 5);
            if (address == null) {
                return null;
            }
            Address location = address.get(0);
            location.getLatitude();
            location.getLongitude();

            return location;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Managing License Expiration flow
    public void manageLicenseExpiration(Context context, String response) {
        try {
            if (SharedPreference.getInstance().getUserDetails() != null &&
                    (SharedPreference.getInstance().getUserDetails().data.role.role_id == EnumConstant.userRole.Inspector.getId() ||
                            SharedPreference.getInstance().getUserDetails().data.role.role_id == EnumConstant.userRole.Owner.getId())) {
                JSONObject object = new JSONObject(response);
                int userAuthenticationStatus = SharedPreference.getInstance().getIntInPref(AppConstant.HI_UserAuthenticationStatus);
                String res = object.getString(AppConstant.HI_res);
                if (res.equalsIgnoreCase("0")) {  // res = 0
                    if (userAuthenticationStatus != EnumConstant.UserAuthenticationStatusEnum.UserSubscriptionExpired.getId()) {
                        redirectOnLicenseExpiration(context, res);
                    }
                    SharedPreference.getInstance().setIntInPref(AppConstant.HI_UserAuthenticationStatus,
                            EnumConstant.UserAuthenticationStatusEnum.UserSubscriptionExpired.getId());
                } else if (res.equalsIgnoreCase("1")) {  // res = 1
                    if (userAuthenticationStatus != EnumConstant.UserAuthenticationStatusEnum.CompanySubscriptionExpired.getId()) {
                        redirectOnLicenseExpiration(context, res);
                    }
                    SharedPreference.getInstance().setIntInPref(AppConstant.HI_UserAuthenticationStatus,
                            EnumConstant.UserAuthenticationStatusEnum.CompanySubscriptionExpired.getId());
                } else {  // res = 3
                    if (userAuthenticationStatus != EnumConstant.UserAuthenticationStatusEnum.UserNotExistAnyMore.getId()) {
                        redirectOnLicenseExpiration(context, res);
                    }
                    SharedPreference.getInstance().setIntInPref(AppConstant.HI_UserAuthenticationStatus,
                            EnumConstant.UserAuthenticationStatusEnum.UserNotExistAnyMore.getId());
                }
            } else {
                showToastLengthLong(context, "Sorry, Your company software license has been expired. You can't access your user account. Please contact to your company administrator.");
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public void redirectOnLicenseExpiration(Context context, String res) {
        Intent intent = new Intent(context, LicenseExpirationActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.putExtra(AppConstant.HI_res, res);
        context.startActivity(intent);
    }

    public String concatName(String fName, String lName) {
        String name = "";
        if (fName != null && !fName.isEmpty())
            name = fName.trim();
        if (lName != null && !lName.isEmpty())
            name = (!name.isEmpty() ? name + " " : "") + lName.trim();
        return name;
    }

    public String concatePricePerDays(String price, String days) {
        String pricePerDays = "";
        if (price != null && !price.isEmpty()) {
            pricePerDays = price.trim();
        }
        if (days != null && !days.isEmpty()) {
            pricePerDays = (!pricePerDays.isEmpty() ? pricePerDays + "/" : "") + days.trim();
        }
        return pricePerDays;
    }

    public int calculateMaxBitmapSize(@NonNull Context context) {
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        Display display = null;
        if (wm != null) {
            display = wm.getDefaultDisplay();
        }

        Point size = new Point();
        int width, height;
        if (display != null) {
            display.getSize(size);
        }
        width = size.x;
        height = size.y;

        int maxBitmapSize = (int) Math.sqrt(Math.pow(width, 2) + Math.pow(height, 2));

        Canvas canvas = new Canvas();
        final int maxCanvasSize = Math.min(canvas.getMaximumBitmapWidth(), canvas.getMaximumBitmapHeight());
        if (maxCanvasSize > 0) {
            maxBitmapSize = Math.min(maxBitmapSize, maxCanvasSize);
        }

        //Log.d("Bitmap Size:", "maxBitmapSize: " + maxBitmapSize);
        return maxBitmapSize;
    }

    public Bitmap decodeSampledBitmapFromFile(String imagePath, int reqWidth, int reqHeight) {

        // First decode with inJustDecodeBounds=true to check dimensions
        final BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(imagePath, options);

        // Calculate inSampleSize
        options.inSampleSize = calculateInSampleSize(options, reqWidth, reqHeight);

        // Decode bitmap with inSampleSize set
        options.inJustDecodeBounds = false;
        //return Bitmap.createScaledBitmap(bt, reqWidth, reqHeight, false);
        return BitmapFactory.decodeFile(imagePath, options);
    }

    public int calculateInSampleSize(
            BitmapFactory.Options options, int reqWidth, int reqHeight) {
        final int height = options.outHeight;
        final int width = options.outWidth;
        int inSampleSize = 1;

        if (height > reqHeight || width > reqWidth) {
            final int halfHeight = height / 2;
            final int halfWidth = width / 2;

            while ((halfHeight / inSampleSize) >= reqHeight
                    && (halfWidth / inSampleSize) >= reqWidth) {
                inSampleSize *= 2;
            }
        }

        //Log.i("Bitmap", "inSampleSize = " + String.valueOf(inSampleSize));

        return inSampleSize;
    }

    public String getRoleName(Long roleID) {
        String userType = "";
        if (roleID == EnumConstant.userRole.SuperAdmin.getId()) {
            userType = EnumConstant.userRole.SuperAdmin.getName();
        } else if (roleID == EnumConstant.userRole.CompanyAdmin.getId()) {
            userType = EnumConstant.userRole.CompanyAdmin.getName();
        } else if (roleID == EnumConstant.userRole.Inspector.getId()) {
            userType = EnumConstant.userRole.Inspector.getName();
        } else if (roleID == EnumConstant.userRole.Owner.getId()) {
            userType = EnumConstant.userRole.Owner.getName();
        } else if (roleID == EnumConstant.userRole.Client.getId()) {
            userType = EnumConstant.userRole.Client.getName();
        } else if (roleID == EnumConstant.userRole.Agent.getId()) {
            userType = EnumConstant.userRole.Agent.getName();
        } else if (roleID == EnumConstant.userRole.OfficeManager.getId()) {
            userType = EnumConstant.userRole.OfficeManager.getName();
        } else if (roleID == EnumConstant.userRole.MarketingCompany.getId()) {
            userType = EnumConstant.userRole.MarketingCompany.getName();
        } else if (roleID == EnumConstant.userRole.CallCenter.getId()) {
            userType = EnumConstant.userRole.CallCenter.getName();
        } else if (roleID == EnumConstant.userRole.SalesPerson.getId()) {
            userType = EnumConstant.userRole.SalesPerson.getName();
        } else if (roleID == EnumConstant.userRole.Developer.getId()) {
            userType = EnumConstant.userRole.Developer.getName();
        } else if (roleID == EnumConstant.userRole.Support.getId()) {
            userType = EnumConstant.userRole.Support.getName();
        }

        return userType;
    }

    public String getRolenameWithCaunse(String roleName) {
        if (roleName != null && !roleName.isEmpty()) {
            roleName = "(" + roleName + ")";
        } else {
            roleName = "";
        }

        return roleName;
    }

    public void helpDialog(Context context, int title, int content) {
        EventBus.getDefault().postSticky(new HomeEnergyHelpEvent(context.getString(title), context.getString(content)));
        context.startActivity(new Intent(context, HomeEnergyHelpDialogActivity.class));
    }

    public void helpDialog(Context context, String title, String content) {
        EventBus.getDefault().postSticky(new HomeEnergyHelpEvent(title, content));
        context.startActivity(new Intent(context, HomeEnergyHelpDialogActivity.class));
    }

    public String getFileExtension(File file) {
        if (file != null) {
            String fileName = file.getName();
            if (fileName.lastIndexOf(".") != -1 && fileName.lastIndexOf(".") != 0)
                return "." + fileName.substring(fileName.lastIndexOf(".") + 1);
            else return AppConstant.HI_VideoFileExtension;
        } else {
            return AppConstant.HI_VideoFileExtension;
        }
    }

    public String getBucketName(File file) {
        if (file != null) {
            String fileName = file.getAbsolutePath();
            String[] stringList = fileName.split("/");
            if (stringList.length > 2) {
                return stringList[stringList.length - 2];
            }
        }
        return AppConstant.HI_Inspection_Protocol;
    }

    // isMatch section name with home energy assessment
    public EnumHomeEnergyConstant.AssessmentsEnum isMatchSectionNameWithHomeEnergyAssessment(String sectionName) {
        if (sectionName != null && !sectionName.isEmpty()) {
            List<String> stringList = Arrays.asList(sectionName.toLowerCase().split("[-_,:;&\\s\\\\/]+"));
            if (stringList != null && !stringList.isEmpty()) {
                for (String value : stringList) {
                    Optional<EnumHomeEnergyConstant.AssessmentsEnum> assessmentsEnumOptional = StreamSupport.
                            stream(EnumHomeEnergyConstant.AssessmentsEnum.getAssessmentsList())
                            .filter(e -> Arrays.asList(e.getArray()).contains(value))
                            .findFirst();
                    if (assessmentsEnumOptional.isPresent()) {
                        return assessmentsEnumOptional.get();
                    }
                }
            }
        }
        return null;
    }

    public void manageHomeEnergyRedirection(Context context, EnumHomeEnergyConstant.AssessmentsEnum assessmentsEnum, InspectionAdapterModel inspectionDetails) {
        if (assessmentsEnum != null) {
            switch (assessmentsEnum) {
                case AboutHome:
                    manageHomeEnergyRedirection(context, AboutHomeActivity.class, inspectionDetails);
                    break;
                case RoofAtticFoundation:
                    manageHomeEnergyRedirection(context, RoofAtticFoundationActivity.class, inspectionDetails);
                    break;
                case Walls:
                    manageHomeEnergyRedirection(context, WallsActivity.class, inspectionDetails);
                    break;
                case WindowsSkylights:
                    manageHomeEnergyRedirection(context, WindowAndSkylightActivity.class, inspectionDetails);
                    break;
                case HeatingCooling:
                    manageHomeEnergyRedirection(context, HeatingAndCoolingSystemActivity.class, inspectionDetails);
                    break;
                case PhotovoltaicSystem:
                    manageHomeEnergyRedirection(context, PhotovoltaicSystemActivity.class, inspectionDetails);
                    break;
                case HomePerformanceWithEnergy:
                    manageHomeEnergyRedirection(context, HomePerformanceActivity.class, inspectionDetails);
                    break;
                default:
                    break;
            }
        }
    }

    // manage Home Energy redirection
    public void manageHomeEnergyRedirection(Context context, Class aClass, InspectionAdapterModel inspectionDetails) {
        Intent intent = new Intent(context, aClass);
        EventBus.getDefault().postSticky(new HomeEnergyAssessmentsEvent(inspectionDetails, null));
        context.startActivity(intent);
    }

    /**
     * InputStreamReader isr = new InputStreamReader(fis);
     BufferedReader  bufferedReader=new BufferedReader(isr);

     StringBuilder sb = new StringBuilder();
     String line;
     while ((line = bufferedReader.readLine()) != null) {
     sb.append(line).append("\n");
     }
     return sb.toString();
     *
     * */

    /**
     * BufferedReader br = new BufferedReader(new FileReader(new File(file, fileName)));
     StringBuilder text = new StringBuilder();
     String line;
     while ((line = br.readLine()) != null) {
     text.append(line);
     }
     br.close();
     text
     * */
}