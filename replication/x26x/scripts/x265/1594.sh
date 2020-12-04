#!/bin/sh

numb='1595'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 1.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.7 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 50 --keyint 250 --lookahead-threads 2 --min-keyint 21 --qp 10 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset slow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,2.5,1.1,1.1,1.6,0.2,0.8,0.7,2,1,16,50,250,2,21,10,5,3,63,18,2,2000,1:1,dia,crop,slow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"