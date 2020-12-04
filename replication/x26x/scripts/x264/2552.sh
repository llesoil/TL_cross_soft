#!/bin/sh

numb='2553'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 4.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.0 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 0 --keyint 270 --lookahead-threads 4 --min-keyint 22 --qp 20 --qpstep 3 --qpmin 2 --qpmax 65 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset slow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.5,1.0,1.0,4.8,0.2,0.8,0.0,1,0,16,0,270,4,22,20,3,2,65,18,6,1000,-2:-2,umh,show,slow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"