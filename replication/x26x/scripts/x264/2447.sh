#!/bin/sh

numb='2448'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 1.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 5 --keyint 210 --lookahead-threads 3 --min-keyint 24 --qp 20 --qpstep 5 --qpmin 4 --qpmax 64 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset slower --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.5,1.3,1.1,1.0,0.6,0.7,0.5,3,1,12,5,210,3,24,20,5,4,64,18,4,1000,-2:-2,umh,crop,slower,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"