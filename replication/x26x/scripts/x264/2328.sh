#!/bin/sh

numb='2329'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 1.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 0 --keyint 230 --lookahead-threads 3 --min-keyint 20 --qp 40 --qpstep 4 --qpmin 4 --qpmax 69 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset veryslow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.5,1.6,1.2,1.2,0.3,0.6,0.8,0,2,6,0,230,3,20,40,4,4,69,28,6,2000,-2:-2,hex,show,veryslow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"