from sqlalchemy import Boolean, Column, Integer, String, ForeignKey, Date, Text, Numeric
from decimal import Decimal
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship

Base = declarative_base()

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(100), unique=True, index=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    is_active = Column(Boolean, default=True)

class PaymentOption(Base):
    __tablename__ = "payment_options"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50), nullable=False)
    description = Column(String(255), nullable=True)
    is_active = Column(Boolean, default=True)

class Payment(Base):
    __tablename__ = "payments"
    
    id = Column(Integer, primary_key=True, index=True)
    booking_id = Column(Integer, ForeignKey("Booking.Booking_ID"), nullable=False)
    amount = Column(Numeric(10, 2), nullable=False)
    payment_option_id = Column(Integer, ForeignKey("payment_options.id"), nullable=False)
    transaction_id = Column(String(100), nullable=True)
    status = Column(String(20), default="Pending")
    payment_date = Column(Date, nullable=True)
    notes = Column(Text, nullable=True)
    
    # Relationships
    booking = relationship("Booking", back_populates="payment")