#!/bin/sh

numb='1109'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 4.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.5 --aq-mode 1 --b-adapt 1 --bframes 2 --crf 45 --keyint 290 --lookahead-threads 1 --min-keyint 22 --qp 40 --qpstep 3 --qpmin 0 --qpmax 66 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset superfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.6,1.2,4.4,0.2,0.7,0.5,1,1,2,45,290,1,22,40,3,0,66,28,6,1000,1:1,hex,show,superfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"