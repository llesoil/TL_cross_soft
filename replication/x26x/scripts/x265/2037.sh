#!/bin/sh

numb='2038'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 0.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.3 --aq-mode 2 --b-adapt 2 --bframes 14 --crf 40 --keyint 250 --lookahead-threads 2 --min-keyint 29 --qp 20 --qpstep 5 --qpmin 3 --qpmax 69 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset placebo --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.5,1.0,1.1,0.6,0.4,0.7,0.3,2,2,14,40,250,2,29,20,5,3,69,18,5,2000,-2:-2,hex,show,placebo,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"