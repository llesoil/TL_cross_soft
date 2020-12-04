#!/bin/sh

numb='1729'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 2.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.4 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 25 --keyint 300 --lookahead-threads 4 --min-keyint 30 --qp 20 --qpstep 5 --qpmin 1 --qpmax 63 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.2,1.1,2.0,0.5,0.8,0.4,2,1,4,25,300,4,30,20,5,1,63,48,6,1000,-2:-2,umh,show,slower,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"