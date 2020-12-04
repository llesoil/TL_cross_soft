#!/bin/sh

numb='782'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 1.4 --qblur 0.5 --qcomp 0.8 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 20 --keyint 200 --lookahead-threads 2 --min-keyint 29 --qp 30 --qpstep 4 --qpmin 3 --qpmax 66 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset ultrafast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,3.0,1.2,1.4,1.4,0.5,0.8,0.7,1,0,4,20,200,2,29,30,4,3,66,48,6,1000,-1:-1,dia,show,ultrafast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"