#!/bin/sh

numb='1895'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 0.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 0 --keyint 300 --lookahead-threads 3 --min-keyint 25 --qp 40 --qpstep 3 --qpmin 3 --qpmax 64 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.5,1.2,1.4,0.2,0.4,0.6,0.2,2,2,2,0,300,3,25,40,3,3,64,28,1,1000,-1:-1,umh,show,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"