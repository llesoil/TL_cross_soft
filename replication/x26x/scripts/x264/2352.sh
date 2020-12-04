#!/bin/sh

numb='2353'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 2.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 15 --keyint 230 --lookahead-threads 4 --min-keyint 29 --qp 10 --qpstep 3 --qpmin 1 --qpmax 69 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset medium --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.5,1.4,1.3,2.6,0.6,0.6,0.4,1,1,6,15,230,4,29,10,3,1,69,48,6,1000,1:1,dia,show,medium,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"