#!/bin/sh

numb='2238'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 3.2 --qblur 0.2 --qcomp 0.7 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 4 --crf 45 --keyint 290 --lookahead-threads 2 --min-keyint 20 --qp 30 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.2,1.2,3.2,0.2,0.7,0.6,2,0,4,45,290,2,20,30,3,4,67,28,1,2000,-2:-2,dia,show,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"