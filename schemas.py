from pydantic import BaseModel, EmailStr

class UserBase(BaseModel):
    email: EmailStr

class UserCreate(UserBase):
    password: str

class User(UserBase):
    id: int
    is_active: bool

    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: str | None = None

class PaymentOptionBase(BaseModel):
    name: str
    description: str = None
    is_active: bool = True

class PaymentOptionCreate(PaymentOptionBase):
    pass

class PaymentOption(PaymentOptionBase):
    id: int
    
    class Config:
        from_attributes = True

class PaymentBase(BaseModel):
    booking_id: int
    amount: float
    payment_option_id: int
    transaction_id: str = None
    status: str = "Pending"
    payment_date: str = None
    notes: str = None

class PaymentCreate(PaymentBase):
    pass

class Payment(PaymentBase):
    id: int
    
    class Config:
        from_attributes = True