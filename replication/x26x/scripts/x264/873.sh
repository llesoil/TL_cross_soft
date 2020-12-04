#!/bin/sh

numb='874'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 3.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 20 --keyint 200 --lookahead-threads 2 --min-keyint 29 --qp 40 --qpstep 4 --qpmin 4 --qpmax 67 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset placebo --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.0,1.1,1.4,3.8,0.2,0.8,0.0,0,1,12,20,200,2,29,40,4,4,67,38,3,1000,-1:-1,umh,crop,placebo,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"