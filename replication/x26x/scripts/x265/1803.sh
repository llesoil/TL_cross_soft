#!/bin/sh

numb='1804'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 5.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.5 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 50 --keyint 250 --lookahead-threads 4 --min-keyint 30 --qp 10 --qpstep 4 --qpmin 1 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset medium --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,2.5,1.3,1.0,5.0,0.3,0.6,0.5,2,1,14,50,250,4,30,10,4,1,63,48,3,1000,-2:-2,dia,crop,medium,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"