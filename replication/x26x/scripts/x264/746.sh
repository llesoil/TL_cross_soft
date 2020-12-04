#!/bin/sh

numb='747'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 40 --keyint 270 --lookahead-threads 0 --min-keyint 29 --qp 50 --qpstep 4 --qpmin 1 --qpmax 64 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset slower --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.5,1.1,1.1,2.6,0.4,0.9,0.5,3,1,6,40,270,0,29,50,4,1,64,18,3,1000,-2:-2,dia,show,slower,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"