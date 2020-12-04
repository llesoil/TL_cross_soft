#!/bin/sh

numb='2955'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 0.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 10 --keyint 230 --lookahead-threads 4 --min-keyint 25 --qp 30 --qpstep 3 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset slow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.0,1.0,1.0,0.8,0.5,0.8,0.4,0,0,6,10,230,4,25,30,3,4,60,38,4,1000,-2:-2,umh,crop,slow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"