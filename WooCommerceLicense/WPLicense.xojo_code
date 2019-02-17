#tag Class
Protected Class WPLicense
Inherits Xojo.Net.HTTPSocket
	#tag Event
		Sub Error(err as RuntimeException)
		  Try
		    me.error = err.Message.ToText
		    wclInterface.wclErrorMessage(me)
		    
		  Catch re As RuntimeException
		    
		    System.DebugLog re.Message
		  End Try
		  'MsgBox err.Message + err.Reason
		End Sub
	#tag EndEvent

	#tag Event
		Sub PageReceived(URL as Text, HTTPStatus as Integer, Content as xojo.Core.MemoryBlock)
		  Try
		    
		    'wclInterface.wclPageReceived(URL, HTTPStatus, Content)
		    dim d as Xojo.Core.Dictionary = ConvertTextToJSON(Content)
		    Active = d.Lookup("activated", false)
		    Success = d.Lookup("success", false)
		    Message = d.Lookup("message", "")
		    error = d.Lookup("error", "")
		    if  d.Lookup("instance", 0) > 0 then instance = d.Lookup("instance", 0)
		    
		    if d.HasKey("activations") then
		      Dim aActivations() as Auto = d.Value("activations")
		      if aActivations.Ubound > -1 then
		        for each item as Xojo.Core.Dictionary in aActivations
		          Activations.Append(item)
		          dim dInstance as Integer = Integer.FromText(item.Lookup("instance", "0"))
		          if dInstance = 0 then Continue
		          if instance = dInstance then
		            Active = true
		            exit
		          end if
		        Next
		      end if
		    end if
		    
		    if not Active then
		      if ActivationAttempt < 1 then
		        Xojo.Core.Timer.CallLater(10000, AddressOf Activate)
		        ActivationAttempt = ActivationAttempt + 1
		      else
		        wclInterface.wcLicenseCheck(me)
		      end if
		      
		    else
		      wclInterface.wcLicenseCheck(me)
		    end if
		    
		    
		    
		  Catch re As RuntimeException
		    
		    System.DebugLog re.Message
		  End Try
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Activate()
		  Dim url as Text = website+"/woocommerce/?wc-api=software-api&request=activation&email="+email+"&license_key="+license_key+"&product_id="+Product_id+"&platform="+Compagnie
		  if instance > 0 then url = url + "&instance="+instance.ToText
		  dim tURL as text = url.ReplaceAll(" ", "").ReplaceAll(Text.FromUnicodeCodepoint(0009), "").ReplaceAccents
		  me.Send("POST", tURL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Check()
		  Dim url as Text = website+"/woocommerce/?wc-api=software-api&request=check&email="+email+"&license_key="+license_key+"&product_id="+Product_id
		  
		  
		  dim tURL as text = url.ReplaceAll(" ", "").ReplaceAll(Text.FromUnicodeCodepoint(0009), "").ReplaceAccents
		  me.Send("POST", tURL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(pInterface as WCLInterface, dLicense as Xojo.Core.Dictionary)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  wclInterface = pInterface
		  website = dLicense.Lookup("website", "https://exemple.com")
		  email = dLicense.Lookup("email", "")
		  instance = dLicense.Lookup("instance", 0)
		  license_key = dLicense.Lookup("license_key", "")
		  Product_id = dLicense.Lookup("Product_id", "")
		  dateAjout = dLicense.Lookup("dateAjout", xojo.core.Date.Now)
		  dateExpiration = dLicense.Lookup("dateExpiration", Xojo.Core.Date.Now)
		  Compagnie = dLicense.Lookup("Compagnie", "")
		  
		  if xojo.core.Date.Now.SecondsFrom1970 - dateAjout.SecondsFrom1970 > 2592000 or  xojo.core.Date.Now.SecondsFrom1970 - dateAjout.SecondsFrom1970 < 1 then
		    if email <> "" AND license_key <> "" AND Product_id <> "" then
		      Check
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ConvertTextToJSON(Content as Xojo.Core.MemoryBlock) As Xojo.Core.Dictionary
		  Dim jsonText As Text = Xojo.Core.TextEncoding.UTF8.ConvertDataToText(Content)
		  return Xojo.Data.ParseJSON(jsonText)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Deactivation()
		  Dim url as Text = website+"/woocommerce/?wc-api=software-api&request=deactivation&email="+email+"&license_key="+license_key+"&product_id="+Product_id+"&instance="+instance.ToText
		  
		  dim tURL as text = url.ReplaceAll(" ", "").ReplaceAll(Text.FromUnicodeCodepoint(0009), "").ReplaceAccents
		  me.Send("POST", tURL)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		ActivationAttempt As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		Activations() As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Active As Boolean = false
	#tag EndProperty

	#tag Property, Flags = &h0
		Compagnie As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		dateAjout As Xojo.Core.Date
	#tag EndProperty

	#tag Property, Flags = &h0
		dateExpiration As Xojo.Core.Date
	#tag EndProperty

	#tag Property, Flags = &h0
		email As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		error As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		instance As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		license_key As Text = "NOKEY"
	#tag EndProperty

	#tag Property, Flags = &h0
		Message As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		Product_id As Text = "NOIDPRODUCT"
	#tag EndProperty

	#tag Property, Flags = &h0
		Success As Boolean = false
	#tag EndProperty

	#tag Property, Flags = &h0
		wclInterface As WooCommerceLicense.WCLInterface
	#tag EndProperty

	#tag Property, Flags = &h0
		website As Text
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ValidateCertificates"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Product_id"
			Group="Behavior"
			InitialValue="NOIDPRODUCT"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ActivationAttempt"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Active"
			Group="Behavior"
			InitialValue="false"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Compagnie"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="email"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="error"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="instance"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="license_key"
			Group="Behavior"
			InitialValue="NOKEY"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Message"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Success"
			Group="Behavior"
			InitialValue="false"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="website"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
