#!/bin/sh

numb='2415'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.5 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 20 --keyint 250 --lookahead-threads 1 --min-keyint 20 --qp 50 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset veryfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.5,1.0,1.3,4.8,0.6,0.9,0.5,1,2,16,20,250,1,20,50,3,2,62,48,1,1000,1:1,dia,crop,veryfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"