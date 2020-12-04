#!/bin/sh

numb='2101'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --intra-refresh --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 2.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 45 --keyint 300 --lookahead-threads 0 --min-keyint 23 --qp 30 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset slower --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,--intra-refresh,None,None,--weightb,0.0,1.6,1.0,2.8,0.6,0.9,0.0,0,1,6,45,300,0,23,30,4,1,62,48,1,1000,1:1,umh,crop,slower,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"