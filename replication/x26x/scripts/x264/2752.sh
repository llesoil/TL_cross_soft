#!/bin/sh

numb='2753'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 1.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 40 --keyint 250 --lookahead-threads 4 --min-keyint 20 --qp 30 --qpstep 4 --qpmin 2 --qpmax 65 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.5,1.1,1.3,1.0,0.5,0.7,0.7,2,0,6,40,250,4,20,30,4,2,65,48,1,1000,-1:-1,hex,show,slower,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"