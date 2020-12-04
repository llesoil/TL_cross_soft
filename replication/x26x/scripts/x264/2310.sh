#!/bin/sh

numb='2311'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 1.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 40 --keyint 280 --lookahead-threads 3 --min-keyint 21 --qp 40 --qpstep 4 --qpmin 3 --qpmax 61 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset veryslow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.6,1.0,1.8,0.3,0.6,0.6,1,2,16,40,280,3,21,40,4,3,61,48,6,2000,1:1,dia,crop,veryslow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"