#!/bin/sh

numb='240'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 2.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 30 --keyint 260 --lookahead-threads 1 --min-keyint 29 --qp 20 --qpstep 5 --qpmin 2 --qpmax 60 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.0,1.4,2.2,0.6,0.7,0.6,0,0,16,30,260,1,29,20,5,2,60,38,3,2000,-1:-1,dia,show,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"