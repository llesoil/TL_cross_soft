#!/bin/sh

numb='1347'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 3.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 40 --keyint 220 --lookahead-threads 0 --min-keyint 30 --qp 50 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset superfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.5,1.1,3.6,0.6,0.7,0.8,2,1,4,40,220,0,30,50,4,0,65,48,1,2000,1:1,umh,show,superfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"