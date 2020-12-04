#!/bin/sh

numb='1130'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 4.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.4 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 5 --keyint 200 --lookahead-threads 4 --min-keyint 20 --qp 40 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.2,1.2,4.4,0.3,0.6,0.4,3,1,8,5,200,4,20,40,3,0,63,48,2,2000,1:1,umh,crop,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"