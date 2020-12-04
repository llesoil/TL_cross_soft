#!/bin/sh

numb='1239'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 1.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.0 --aq-mode 2 --b-adapt 0 --bframes 10 --crf 35 --keyint 250 --lookahead-threads 0 --min-keyint 25 --qp 20 --qpstep 3 --qpmin 2 --qpmax 66 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset veryslow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.1,1.1,1.8,0.5,0.8,0.0,2,0,10,35,250,0,25,20,3,2,66,18,3,2000,-2:-2,umh,show,veryslow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"