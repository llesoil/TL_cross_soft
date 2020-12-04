#!/bin/sh

numb='1565'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 0.4 --qblur 0.2 --qcomp 0.6 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 20 --keyint 260 --lookahead-threads 3 --min-keyint 29 --qp 0 --qpstep 4 --qpmin 1 --qpmax 60 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset superfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.0,1.1,1.3,0.4,0.2,0.6,0.0,2,2,10,20,260,3,29,0,4,1,60,48,6,2000,1:1,dia,crop,superfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"