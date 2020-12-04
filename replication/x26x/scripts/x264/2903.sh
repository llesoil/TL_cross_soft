#!/bin/sh

numb='2904'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 3.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 4 --crf 10 --keyint 210 --lookahead-threads 0 --min-keyint 29 --qp 20 --qpstep 5 --qpmin 1 --qpmax 68 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset slower --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.5,1.6,1.4,3.4,0.3,0.8,0.1,3,1,4,10,210,0,29,20,5,1,68,48,4,1000,-1:-1,umh,show,slower,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"